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
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | ~> 9.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_target_group_attachments"></a> [additional\_target\_group\_attachments](#input\_additional\_target\_group\_attachments) | Map of extra target attachments for terraform-aws-modules/alb (e.g. multiple EC2 instances per target group) | `any` | `null` | no |
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | Name of the ALB | `string` | n/a | yes |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | If true, cross-zone load balancing of the load balancer will be enabled | `bool` | `true` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | If true, deletion of the load balancer will be disabled | `bool` | `true` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | If true, the ALB will be internal | `bool` | `true` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | List of maps defining the ALB listeners | `any` | n/a | yes |
| <a name="input_logs_s3_bucket_id"></a> [logs\_s3\_bucket\_id](#input\_logs\_s3\_bucket\_id) | S3 bucket for ALB logs | `string` | `""` | no |
| <a name="input_preserve_host_header"></a> [preserve\_host\_header](#input\_preserve\_host\_header) | Host header preservation setting | `bool` | `false` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security groups to assign to the ALB | `list(string)` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets to place the ALB | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | n/a | yes |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | List of maps defining the ALB target groups | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | The ARN of the ALB |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | The DNS name of the ALB |
| <a name="output_alb_zone_id"></a> [alb\_zone\_id](#output\_alb\_zone\_id) | The zone id of the ALB |
<!-- END_TF_DOCS -->
