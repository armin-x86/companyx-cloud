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
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability zones to place subnets | `list(string)` | n/a | yes |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR block for the VPC | `string` | n/a | yes |
| <a name="input_external_nat_ip_ids_list"></a> [external\_nat\_ip\_ids\_list](#input\_external\_nat\_ip\_ids\_list) | List of EIP IDs to be assigned to the NAT Gateways if reuse\_nat\_ips\_enabled is set to true | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The unique vpc name to assign to the resources | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace for tagging | `string` | n/a | yes |
| <a name="input_one_nat_gateway_per_az_enabled"></a> [one\_nat\_gateway\_per\_az\_enabled](#input\_one\_nat\_gateway\_per\_az\_enabled) | This has no effect if single\_nat\_gateway is set to true. Set to True so you will have on NGW per AZ. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs` | `bool` | `true` | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | The list of CIDRs for cluster private subnets | `list(string)` | n/a | yes |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | The tags for private subnets | `map(string)` | `null` | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | The list of CIDRs for cluster public subnets | `list(string)` | n/a | yes |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | The tags for public subnets | `map(string)` | `null` | no |
| <a name="input_reuse_nat_ips_enabled"></a> [reuse\_nat\_ips\_enabled](#input\_reuse\_nat\_ips\_enabled) | Enable/Disable using an already created EIP for NGW. If set to True, 'external\_nat\_ip\_ids' variable should be passed down to the module | `bool` | `false` | no |
| <a name="input_single_nat_gateway_enabled"></a> [single\_nat\_gateway\_enabled](#input\_single\_nat\_gateway\_enabled) | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_flow_log_enabled"></a> [vpc\_flow\_log\_enabled](#input\_vpc\_flow\_log\_enabled) | Enable/Disable flow logs | `bool` | `true` | no |
| <a name="input_vpc_flow_logs_bucket"></a> [vpc\_flow\_logs\_bucket](#input\_vpc\_flow\_logs\_bucket) | The S3 bucket of vpc flow logs | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | List of IDs of private route tables |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | List of IDs of public route tables |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags of the VPC |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | Name of the VPC |
| <a name="output_vpc_nat_public_ips"></a> [vpc\_nat\_public\_ips](#output\_vpc\_nat\_public\_ips) | List of public Elastic IPs created for AWS NAT Gateway |
| <a name="output_vpc_private_subnet_ids"></a> [vpc\_private\_subnet\_ids](#output\_vpc\_private\_subnet\_ids) | List of IDs of private subnets |
| <a name="output_vpc_public_subnet_ids"></a> [vpc\_public\_subnet\_ids](#output\_vpc\_public\_subnet\_ids) | List of ids of public subnets |
<!-- END_TF_DOCS -->
