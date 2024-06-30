<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_k8s"></a> [k8s](#module\_k8s) | ./modules/compute | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | Number of aws account | `number` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | profile for execute terraform | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | value for aws region | `string` | `"us-east-1"` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | Name of IAM ROLE for switch role | `string` | n/a | yes |
| <a name="input_ssh_key_path"></a> [ssh\_key\_path](#input\_ssh\_key\_path) | SSH key path | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_k8s_master_ips"></a> [k8s\_master\_ips](#output\_k8s\_master\_ips) | IPs of instances masters |
| <a name="output_k8s_workers_ips"></a> [k8s\_workers\_ips](#output\_k8s\_workers\_ips) | IPs of instances workers |
| <a name="output_network_ip_nat_gateway"></a> [network\_ip\_nat\_gateway](#output\_network\_ip\_nat\_gateway) | IPs of instances workers |
<!-- END_TF_DOCS -->
