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

resource "aws_kinesis_firehose_delivery_stream" "delivery_stream" {
  name        = var.delivery_stream_name
  destination = local.destination

  http_endpoint_configuration {
    url                = var.http_endpoint_url
    name               = var.http_endpoint_name
    buffering_size     = var.http_endpoint_buffer_size_mb
    buffering_interval = var.http_endpoint_buffer_interval_seconds
    role_arn           = var.consumer_role_arn
    s3_backup_mode     = var.s3_backup_mode

    s3_configuration {
      role_arn            = var.consumer_role_arn
      bucket_arn          = var.s3_endpoint_bucket_arn
      buffering_size      = var.s3_endpoint_buffer_size_mb
      buffering_interval  = var.s3_endpoint_buffer_interval_seconds
      compression_format  = var.s3_endpoint_compression_format
      error_output_prefix = var.s3_error_output_prefix
    }

    dynamic "cloudwatch_logging_options" {
      for_each = var.enable_cloudwatch_logs_delivery ? [1] : []

      content {
        enabled         = var.enable_cloudwatch_logs_delivery
        log_group_name  = var.cloudwatch_log_group_name
        log_stream_name = var.cloudwatch_log_stream_name
      }
    }

    request_configuration {
      content_encoding = var.http_endpoint_compression_format
    }
  }
  tags = local.tags
}
