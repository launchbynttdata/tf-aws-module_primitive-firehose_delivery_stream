# tf-aws-module_primitive-firehose_delivery_stream

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

Creates a Kinesis Firehose Delivery Stream targeting an HTTP source.

- A consumer role is passed in as a variable to this module with rights to read the stream, put failed records in an S3 bucket, and optionally deliver log records to CloudWatch Logs. There is no special IAM permission associated with delivery to an external HTTP endpoint (e.g. Sumo Logic).
  - The consumer role is always assumed by the Firehose and does not allow custom assumption policies like the producer role.

This module allows for optional delivery of stream logs to Cloudwatch Logs, but will not allow creation of a subscription filter on the log group it creates by default to avoid situations where logs are sent in circles.

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kinesis_firehose_delivery_stream.delivery_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |

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
| <a name="input_delivery_stream_name"></a> [delivery\_stream\_name](#input\_delivery\_stream\_name) | Name of the Delivery Stream. | `string` | n/a | yes |
| <a name="input_http_endpoint_url"></a> [http\_endpoint\_url](#input\_http\_endpoint\_url) | URL to which the Delivery Stream should deliver its records. | `string` | n/a | yes |
| <a name="input_http_endpoint_name"></a> [http\_endpoint\_name](#input\_http\_endpoint\_name) | Friendly name for the HTTP endpoint associated with this Delivery Stream. | `string` | n/a | yes |
| <a name="input_http_endpoint_buffer_size_mb"></a> [http\_endpoint\_buffer\_size\_mb](#input\_http\_endpoint\_buffer\_size\_mb) | Maxmimum size in megabytes to buffer before delivering to the HTTP endpoint | `number` | `4` | no |
| <a name="input_http_endpoint_buffer_interval_seconds"></a> [http\_endpoint\_buffer\_interval\_seconds](#input\_http\_endpoint\_buffer\_interval\_seconds) | Maximum number of seconds to buffer before delivering to the HTTP endpoint | `number` | `60` | no |
| <a name="input_http_endpoint_compression_format"></a> [http\_endpoint\_compression\_format](#input\_http\_endpoint\_compression\_format) | Compression format used sending records to an HTTP endpoint. Defaults to GZIP, use NONE to disable compression. | `string` | `"GZIP"` | no |
| <a name="input_s3_backup_mode"></a> [s3\_backup\_mode](#input\_s3\_backup\_mode) | Determines how documents should be delivered to S3. Valid options are 'AllData' and 'FailedDataOnly' (default). | `string` | `"FailedDataOnly"` | no |
| <a name="input_s3_endpoint_bucket_arn"></a> [s3\_endpoint\_bucket\_arn](#input\_s3\_endpoint\_bucket\_arn) | ARN of an S3 bucket to use as a destination | `string` | n/a | yes |
| <a name="input_s3_endpoint_buffer_size_mb"></a> [s3\_endpoint\_buffer\_size\_mb](#input\_s3\_endpoint\_buffer\_size\_mb) | Maxmimum size in megabytes to buffer before delivering to the S3 endpoint | `number` | `4` | no |
| <a name="input_s3_endpoint_buffer_interval_seconds"></a> [s3\_endpoint\_buffer\_interval\_seconds](#input\_s3\_endpoint\_buffer\_interval\_seconds) | Maximum number of seconds to buffer before delivering to the S3 endpoint | `number` | `60` | no |
| <a name="input_s3_endpoint_compression_format"></a> [s3\_endpoint\_compression\_format](#input\_s3\_endpoint\_compression\_format) | Compression format used when saving records to S3. Defaults to GZIP, also supports ZIP, Snappy, and HADOOP\_SNAPPY. Use an empty string to disable compression. | `string` | `"GZIP"` | no |
| <a name="input_enable_cloudwatch_logs_delivery"></a> [enable\_cloudwatch\_logs\_delivery](#input\_enable\_cloudwatch\_logs\_delivery) | Enable delivery of logs to CloudWatch. | `bool` | `false` | no |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | CloudWatch Log Group Name that should be used to log items for this Delivery Stream. Required if enable\_cloudwatch\_logs\_delivery is true. | `string` | `null` | no |
| <a name="input_cloudwatch_log_stream_name"></a> [cloudwatch\_log\_stream\_name](#input\_cloudwatch\_log\_stream\_name) | Name that should be used for the CloudWatch Log Stream containing delivery logs. | `string` | `"HttpEndpointDelivery"` | no |
| <a name="input_s3_error_output_prefix"></a> [s3\_error\_output\_prefix](#input\_s3\_error\_output\_prefix) | Prefix to add onto any records saved to S3 that fail delivery to the HTTP target. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the resources created by the module. | `map(string)` | `{}` | no |
| <a name="input_consumer_role_arn"></a> [consumer\_role\_arn](#input\_consumer\_role\_arn) | Role with the necessary policies to consume records from this Delivery Stream, send failed records to S3, and log messages to CloudWatch (if using enable\_cloudwatch\_logs\_delivery). | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the delivery streams. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
| <a name="output_name"></a> [name](#output\_name) | The name of the delivery stream |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
