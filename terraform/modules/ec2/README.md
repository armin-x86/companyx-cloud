<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_instance"></a> [ec2\_instance](#module\_ec2\_instance) | terraform-aws-modules/ec2-instance/aws | ~> 5.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | The AMI to use for the EC2 instance | `string` | n/a | yes |
| <a name="input_create_iam_instance_profile"></a> [create\_iam\_instance\_profile](#input\_create\_iam\_instance\_profile) | Whether to create an IAM instance profile for the EC2 instance | `bool` | `true` | no |
| <a name="input_create_instance"></a> [create\_instance](#input\_create\_instance) | Whether to create the EC2 instance | `bool` | `true` | no |
| <a name="input_ebs_block_device"></a> [ebs\_block\_device](#input\_ebs\_block\_device) | The EBS block device configuration | `any` | `[]` | no |
| <a name="input_eip"></a> [eip](#input\_eip) | Whether to create an Elastic IP and associate it with the EC2 instance | `bool` | `false` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | The IAM instance profile to associate with the EC2 instance | `string` | `""` | no |
| <a name="input_iam_role_name_suffix"></a> [iam\_role\_name\_suffix](#input\_iam\_role\_name\_suffix) | The IAM instance name suffix | `string` | `""` | no |
| <a name="input_ignore_ami_changes"></a> [ignore\_ami\_changes](#input\_ignore\_ami\_changes) | Whether to ignore the AMI configuration changes | `bool` | `true` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name of the EC2 instance | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of EC2 instance to launch | `string` | `"t3a.nano"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the EC2 key pair to use | `string` | `null` | no |
| <a name="input_metadata_options"></a> [metadata\_options](#input\_metadata\_options) | The metadata options for the EC2 instance | `any` | <pre>{<br/>  "http_tokens": "required"<br/>}</pre> | no |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | The root block device configuration | `any` | <pre>[<br/>  {<br/>    "encrypted": true,<br/>    "volume_size": 15,<br/>    "volume_type": "gp3"<br/>  }<br/>]</pre> | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of the subnet to launch the EC2 instance into | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the EC2 instance | `any` | n/a | yes |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The user data to provide when launching the EC2 instance | `string` | `""` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | A list of security group IDs to associate with the EC2 instance | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_instance_id"></a> [ec2\_instance\_id](#output\_ec2\_instance\_id) | The ID of the EC2 instance |
| <a name="output_ec2_instance_private_ip"></a> [ec2\_instance\_private\_ip](#output\_ec2\_instance\_private\_ip) | The private IP address of the EC2 instance |
| <a name="output_ec2_instance_public_ip"></a> [ec2\_instance\_public\_ip](#output\_ec2\_instance\_public\_ip) | The public IP address of the EC2 instance |
<!-- END_TF_DOCS -->
