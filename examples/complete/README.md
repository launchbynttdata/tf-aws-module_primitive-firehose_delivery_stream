<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, <= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.64.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 1.0 |
| <a name="module_firehose_delivery_stream"></a> [firehose\_delivery\_stream](#module\_firehose\_delivery\_stream) | ../.. | n/a |
| <a name="module_cloudwatch_log_group"></a> [cloudwatch\_log\_group](#module\_cloudwatch\_log\_group) | git::https://github.com/launchbynttdata/tf-aws-module_primitive-cloudwatch_log_group.git | 1.0.1 |
| <a name="module_s3_destination_bucket"></a> [s3\_destination\_bucket](#module\_s3\_destination\_bucket) | git::https://github.com/launchbynttdata/tf-aws-module_collection-s3_bucket | 1.0.0 |
| <a name="module_consumer_role"></a> [consumer\_role](#module\_consumer\_role) | git::https://github.com/launchbynttdata/tf-aws-module_collection-iam_assumable_role.git | 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.consumer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"backend"` | no |
| <a name="input_region"></a> [region](#input\_region) | (Required) The location where the resource will be created. Must not have spaces<br>    For example, us-east-1, us-west-2, eu-west-1, etc. | `string` | `"us-east-2"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_maximum_length"></a> [maximum\_length](#input\_maximum\_length) | Number that represents the maximum length the resource name could have. | `number` | `60` | no |
| <a name="input_separator"></a> [separator](#input\_separator) | Separator to be used in the name | `string` | `"-"` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "consumer_role": {<br>    "max_length": 60,<br>    "name": "cnsmr"<br>  },<br>  "delivery_stream": {<br>    "max_length": 60,<br>    "name": "ds"<br>  },<br>  "iam_policy": {<br>    "max_length": 60,<br>    "name": "iamp"<br>  },<br>  "iam_role": {<br>    "max_length": 60,<br>    "name": "iamr"<br>  },<br>  "log_group": {<br>    "max_length": 60,<br>    "name": "lg"<br>  },<br>  "s3": {<br>    "max_length": 63,<br>    "name": "dlvstrm"<br>  }<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `number` | `"000"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `number` | `"000"` | no |
| <a name="input_http_endpoint_url"></a> [http\_endpoint\_url](#input\_http\_endpoint\_url) | URL to which the Delivery Stream should deliver its records. | `string` | n/a | yes |
| <a name="input_http_endpoint_name"></a> [http\_endpoint\_name](#input\_http\_endpoint\_name) | Friendly name for the HTTP endpoint associated with this Delivery Stream. | `string` | n/a | yes |
| <a name="input_consumer_trusted_services"></a> [consumer\_trusted\_services](#input\_consumer\_trusted\_services) | Trusted service used for the assumption policy when creating the consumer role. Defaults to the firehose service. | `string` | `null` | no |
| <a name="input_consumer_external_id"></a> [consumer\_external\_id](#input\_consumer\_external\_id) | STS External ID used for the assumption policy when creating the consumer role. Defaults to the current AWS account ID. | `string` | `null` | no |
| <a name="input_s3_error_prefix"></a> [s3\_error\_prefix](#input\_s3\_error\_prefix) | Prefix to prepend to failed records being sent to S3. Ensure this value contains a trailing slash if set to anything other than an empty string. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the delivery streams. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
| <a name="output_name"></a> [name](#output\_name) | The name of the delivery stream |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
