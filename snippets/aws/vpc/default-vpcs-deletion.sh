#!/usr/bin/env bash

# Note:	Use Bash 4.0+
#   On mac you install `bash` with brew and it will reside in /Users/yourusername/homebrew/bin/bash
#     e.g: /Users/yourusername/homebrew/bin/bash default-vpcs-deletion.sh
#
#   AWS_PROFILE:
#     ensure you have switched to the related profile:
#     export AWS_PROFILE=PROFILE_NAME_HERE

# When you create a new AWS account it comes with a default VPC in all
# available regions for the account. You will need to get rid of these
# default VPCs before doing anything else.
# This script detects them and ensure there is no resource provisioned
# there and then helps you to delete it in one go.

set -euo pipefail

declare -A vpc_usage
declare -A vpc_regions

account_id=$(aws sts get-caller-identity | awk -F'"' '/"Account"/ {print $4}')
echo ""
echo "Scanning $account_id account for default VPCs and their usage across all AWS regions..."
echo ""



# Step 1: Check all regions
for region in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text); do
  vpc_id=$(aws ec2 describe-vpcs \
    --region "$region" \
    --filters Name=isDefault,Values=true \
    --query "Vpcs[0].VpcId" \
    --output text)

  if [[ "$vpc_id" == "None" ]]; then
    continue
  fi

  echo "Default VPC in $region: $vpc_id"

  ec2_count=$(aws ec2 describe-instances \
    --region "$region" \
    --filters Name=vpc-id,Values="$vpc_id" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text | wc -w)

  eni_count=$(aws ec2 describe-network-interfaces \
    --region "$region" \
    --filters Name=vpc-id,Values="$vpc_id" \
    --query "NetworkInterfaces[*].NetworkInterfaceId" \
    --output text | wc -w)

  rds_count=$(aws rds describe-db-instances \
    --region "$region" \
    --query "DBInstances[?DBSubnetGroup.VpcId=='$vpc_id'].DBInstanceIdentifier" \
    --output text | wc -w)

  lambda_count=$(aws lambda list-functions \
    --region "$region" \
    --query "Functions[?VpcConfig.VpcId=='$vpc_id'].FunctionName" \
    --output text | wc -w)

  # EKS count
  eks_clusters=$(aws eks list-clusters --region "$region" --query "clusters[]" --output text)
  eks_count=0
  for cluster in $eks_clusters; do
    cluster_vpc=$(aws eks describe-cluster --name "$cluster" --region "$region" --query "cluster.resourcesVpcConfig.vpcId" --output text 2>/dev/null || echo "N/A")
    if [[ "$cluster_vpc" == "$vpc_id" ]]; then
      ((eks_count+=1))
    fi
  done

  total=$((ec2_count + eni_count + rds_count + lambda_count + eks_count))
  vpc_usage["$vpc_id"]=$total
  vpc_regions["$vpc_id"]=$region

  echo "    EC2: $ec2_count, ENIs: $eni_count, RDS: $rds_count, Lambda: $lambda_count, EKS clusters: $eks_count"
  echo ""
done


# Step 2: Print summary
echo "Scan complete."
echo ""
echo "VPC Deletion Summary for Account ID $account_id:"
echo "------------------------"

safe_vpcs=()
for vpc_id in "${!vpc_usage[@]}"; do
  region="${vpc_regions[$vpc_id]}"
  usage="${vpc_usage[$vpc_id]}"
  if [[ "$usage" -eq 0 ]]; then
    echo "$vpc_id in $region is safe to delete."
    safe_vpcs+=("$vpc_id")
  else
    echo "❌ $vpc_id in $region is in use and should NOT be deleted."
  fi
done

echo ""
read -p "Do you want to proceed with default VPC deletions? (yes/no): " confirm
if [[ "$confirm" != "yes" ]]; then
  echo "❌ Aborted."
  exit 0
fi

echo ""
read -p "Do you want selective deletion or delete all safe VPCs? (selective/all): " mode

if [[ "$mode" == "all" ]]; then
  targets=("${safe_vpcs[@]}")
elif [[ "$mode" == "selective" ]]; then
  echo ""
  read -p "Enter comma-separated list of VPC IDs to delete: " vpc_list_raw
  IFS=',' read -r -a targets <<< "$vpc_list_raw"
else
  echo "❌ Invalid mode. Exiting."
  exit 1
fi

echo ""
echo "Proceeding to delete the following VPCs in Account ID $account_id:"
printf ' - %s\n' "${targets[@]}"
echo ""
read -p "Final confirmation: Type 'delete' to proceed: " final
if [[ "$final" != "delete" ]]; then
  echo "❌ Deletion canceled."
  exit 0
fi

# Step 3: Deletion
for vpc_id in "${targets[@]}"; do
  region="${vpc_regions[$vpc_id]}"
  echo " Deleting $vpc_id in $region..."

  # Detach & delete IGW
  igw_id=$(aws ec2 describe-internet-gateways --region "$region" \
    --filters Name=attachment.vpc-id,Values="$vpc_id" \
    --query "InternetGateways[0].InternetGatewayId" --output text)
  if [[ "$igw_id" != "None" ]]; then
    aws ec2 detach-internet-gateway --internet-gateway-id "$igw_id" --vpc-id "$vpc_id" --region "$region"
    aws ec2 delete-internet-gateway --internet-gateway-id "$igw_id" --region "$region"
  fi

  # Delete subnets
  subnet_ids=$(aws ec2 describe-subnets --region "$region" --filters Name=vpc-id,Values="$vpc_id" --query "Subnets[*].SubnetId" --output text)
  for subnet in $subnet_ids; do
    aws ec2 delete-subnet --subnet-id "$subnet" --region "$region"
  done

  # Delete route tables (non-main)
  rt_ids=$(aws ec2 describe-route-tables --region "$region" --filters Name=vpc-id,Values="$vpc_id" --query "RouteTables[*].RouteTableId" --output text)
  for rt_id in $rt_ids; do
    is_main=$(aws ec2 describe-route-tables --region "$region" --route-table-ids "$rt_id" --query "RouteTables[0].Associations[0].Main" --output text)
    if [[ "$is_main" != "True" ]]; then
      aws ec2 delete-route-table --route-table-id "$rt_id" --region "$region"
    fi
  done

  # Delete non-default SGs
  sg_ids=$(aws ec2 describe-security-groups --region "$region" --filters Name=vpc-id,Values="$vpc_id" --query "SecurityGroups[?GroupName!='default'].GroupId" --output text)
  for sg_id in $sg_ids; do
    aws ec2 delete-security-group --group-id "$sg_id" --region "$region"
  done

  # Delete non-default NACLs
  nacl_ids=$(aws ec2 describe-network-acls --region "$region" --filters Name=vpc-id,Values="$vpc_id" --query "NetworkAcls[?IsDefault==\`false\`].NetworkAclId" --output text)
  for nacl_id in $nacl_ids; do
    aws ec2 delete-network-acl --network-acl-id "$nacl_id" --region "$region"
  done

  # Delete the VPC
  aws ec2 delete-vpc --vpc-id "$vpc_id" --region "$region"

  echo "Deleted $vpc_id in $region."
done

echo ""
echo " Done. Selected VPCs have been deleted."
