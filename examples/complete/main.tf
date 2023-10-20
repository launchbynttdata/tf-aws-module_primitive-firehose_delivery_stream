// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

data "aws_caller_identity" "current" {}

module "resource_names" {
  source = "git::https://github.com/nexient-llc/tf-module-resource_name.git?ref=0.1.0"

  for_each = var.resource_names_map

  logical_product_name = var.naming_prefix
  region               = join("", split("-", var.region))
  class_env            = var.environment
  cloud_resource_type  = each.value.name
  instance_env         = var.environment_number
  instance_resource    = var.resource_number
  maximum_length       = each.value.max_length
}

module "firehose_delivery_stream" {
  source = "../.."

  delivery_stream_name   = module.resource_names["delivery_stream"].standard
  http_endpoint_url      = var.http_endpoint_url
  http_endpoint_name     = var.http_endpoint_name
  s3_endpoint_bucket_arn = module.s3_destination_bucket.arn
  s3_error_output_prefix = var.s3_error_prefix

  consumer_role_arn = module.consumer_role.assumable_iam_role

  tags = { resource_name = module.resource_names["delivery_stream"].standard }
}

module "cloudwatch_log_group" {
  source = "git::https://github.com/nexient-llc/tf-aws-module-cloudwatch_log_group.git?ref=0.1.0"

  name = module.resource_names["log_group"].standard
  tags = { resource_name = module.resource_names["log_group"].standard }
}

module "s3_destination_bucket" {
  source = "git::https://github.com/nexient-llc/tf-aws-wrapper_module-s3_bucket?ref=0.1.0"

  naming_prefix      = var.naming_prefix
  environment        = var.environment
  environment_number = var.environment_number
  region             = var.region
  resource_number    = var.resource_number

  enable_versioning = true
}

module "consumer_role" {
  source = "git::https://github.com/nexient-llc/tf-aws-wrapper_module-iam_assumable_role.git?ref=0.1.0"

  naming_prefix      = var.naming_prefix
  environment        = var.environment
  environment_number = var.environment_number
  region             = var.region
  resource_number    = var.resource_number

  resource_names_map = {
    iam_role   = var.resource_names_map["consumer_role"]
    iam_policy = var.resource_names_map["consumer_policy"]
  }

  assume_iam_role_policies = [data.aws_iam_policy_document.consumer_policy.json]
  trusted_role_services    = local.consumer_trusted_services
  role_sts_externalid      = local.consumer_external_id
}

data "aws_iam_policy_document" "consumer_policy" {
  statement {
    sid    = "FailedLogsS3Interactions"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      "${module.s3_destination_bucket.arn}",
      "${module.s3_destination_bucket.arn}/*"
    ]
  }

  statement {
    sid    = "PutLogEvents"
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream"
    ]
    resources = [
      module.cloudwatch_log_group.log_group_arn
    ]
  }

  statement {
    sid    = "StreamInteractions"
    effect = "Allow"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards"
    ]
    resources = [
      "arn:aws:firehose:${var.region}:${local.account_id}:deliverystream/${module.resource_names["delivery_stream"].standard}"
    ]
  }

  statement {
    sid    = "PassRole"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "arn:aws:firehose:${var.region}:${local.account_id}:role/${module.resource_names["consumer_role"].standard}"
    ]
  }
}
