<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | git::https://github.com/nexient-llc/tf-module-resource_name.git | 0.1.0 |
| <a name="module_firehose_delivery_stream"></a> [firehose\_delivery\_stream](#module\_firehose\_delivery\_stream) | ../.. | n/a |
| <a name="module_cloudwatch_log_group"></a> [cloudwatch\_log\_group](#module\_cloudwatch\_log\_group) | git::https://github.com/nexient-llc/tf-aws-module-cloudwatch_log_group.git | 0.1.0 |
| <a name="module_s3_destination_bucket"></a> [s3\_destination\_bucket](#module\_s3\_destination\_bucket) | git::https://github.com/nexient-llc/tf-aws-wrapper_module-s3_bucket | 0.1.0 |
| <a name="module_consumer_role"></a> [consumer\_role](#module\_consumer\_role) | git::https://github.com/nexient-llc/tf-aws-wrapper_module-iam_assumable_role.git | 0.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.consumer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-module-resource\_name to generate resource names | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "consumer_policy": {<br>    "max_length": 60,<br>    "name": "cnsmr-plcy"<br>  },<br>  "consumer_role": {<br>    "max_length": 60,<br>    "name": "cnsmr-role"<br>  },<br>  "delivery_stream": {<br>    "max_length": 60,<br>    "name": "ds"<br>  },<br>  "log_group": {<br>    "max_length": 60,<br>    "name": "lg"<br>  },<br>  "producer_policy": {<br>    "max_length": 60,<br>    "name": "prdcr-plcy"<br>  },<br>  "producer_role": {<br>    "max_length": 60,<br>    "name": "prdcr-role"<br>  },<br>  "s3": {<br>    "max_length": 63,<br>    "name": "s3"<br>  },<br>  "subscription_filter": {<br>    "max_length": 60,<br>    "name": "sub-fltr"<br>  }<br>}</pre> | no |
| <a name="input_naming_prefix"></a> [naming\_prefix](#input\_naming\_prefix) | Prefix for the provisioned resources. | `string` | `"platform"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region in which the infra needs to be provisioned | `string` | `"us-east-2"` | no |
| <a name="input_resource_number"></a> [resource\_number](#input\_resource\_number) | The resource count for the respective resource. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_http_endpoint_url"></a> [http\_endpoint\_url](#input\_http\_endpoint\_url) | URL to which the Delivery Stream should deliver its records. | `string` | n/a | yes |
| <a name="input_http_endpoint_name"></a> [http\_endpoint\_name](#input\_http\_endpoint\_name) | Friendly name for the HTTP endpoint associated with this Delivery Stream. | `string` | n/a | yes |
| <a name="input_consumer_trusted_services"></a> [consumer\_trusted\_services](#input\_consumer\_trusted\_services) | Trusted service used for the assumption policy when creating the consumer role. Defaults to the firehose service. | `string` | `null` | no |
| <a name="input_consumer_external_id"></a> [consumer\_external\_id](#input\_consumer\_external\_id) | STS External ID used for the assumption policy when creating the consumer role. Defaults to the current AWS account ID. | `string` | `null` | no |
| <a name="input_producer_trusted_services"></a> [producer\_trusted\_services](#input\_producer\_trusted\_services) | Trusted service used for the assumption policy when creating the producer role. Defaults to the logs service for the current AWS region. | `string` | `null` | no |
| <a name="input_producer_external_id"></a> [producer\_external\_id](#input\_producer\_external\_id) | STS External ID used for the assumption policy when creating the producer role. | `list(string)` | `null` | no |
| <a name="input_s3_error_prefix"></a> [s3\_error\_prefix](#input\_s3\_error\_prefix) | Prefix to prepend to failed records being sent to S3. Ensure this value contains a trailing slash if set to anything other than an empty string. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the resources created by the module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_delivery_stream_arn"></a> [delivery\_stream\_arn](#output\_delivery\_stream\_arn) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
