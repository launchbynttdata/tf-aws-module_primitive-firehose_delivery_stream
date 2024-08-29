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

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false
  default     = "launch"

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }
}
variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false
  default     = "backend"

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }
}

variable "region" {
  type        = string
  description = <<EOF
    (Required) The location where the resource will be created. Must not have spaces
    For example, us-east-1, us-west-2, eu-west-1, etc.
  EOF
  nullable    = false
  default     = "us-east-2"

  validation {
    condition     = length(regexall("\\b \\b", var.region)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

variable "class_env" {
  type        = string
  default     = "dev"
  description = "(Required) Environment where resource is going to be deployed. For example. dev, qa, uat"
  nullable    = false

  validation {
    condition     = length(regexall("\\b \\b", var.class_env)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

variable "instance_env" {
  type        = number
  description = "Number that represents the instance of the environment."
  default     = 0

  validation {
    condition     = var.instance_env >= 0 && var.instance_env <= 999
    error_message = "Instance number should be between 1 to 999."
  }
}

variable "instance_resource" {
  type        = number
  description = "Number that represents the instance of the resource."
  default     = 0

  validation {
    condition     = var.instance_resource >= 0 && var.instance_resource <= 100
    error_message = "Instance number should be between 1 to 100."
  }
}

variable "maximum_length" {
  type        = number
  description = "Number that represents the maximum length the resource name could have."
  default     = 60

  validation {
    condition     = var.maximum_length >= 10 && var.maximum_length <= 512
    error_message = "Maximum length number should be between 10 to 512."
  }
}

variable "separator" {
  type        = string
  description = "Separator to be used in the name"
  default     = "-"

  validation {
    condition     = length(trimspace(var.separator)) == 1
    error_message = "Length of the separator must be 1 character."
  }

  validation {
    condition     = length(regexall("[._-]", var.separator)) > 0
    error_message = "Only '.', '_', '-' are allowed as separator."
  }
}


variable "delivery_stream_name" {
  description = "Name of the Delivery Stream."
  type        = string
}

variable "http_endpoint_url" {
  description = "URL to which the Delivery Stream should deliver its records."
  type        = string
}

variable "http_endpoint_name" {
  description = "Friendly name for the HTTP endpoint associated with this Delivery Stream."
  type        = string
}

variable "http_endpoint_buffer_size_mb" {
  description = "Maxmimum size in megabytes to buffer before delivering to the HTTP endpoint"
  type        = number
  default     = 4
}

variable "http_endpoint_buffer_interval_seconds" {
  description = "Maximum number of seconds to buffer before delivering to the HTTP endpoint"
  type        = number
  default     = 60
}

variable "http_endpoint_compression_format" {
  description = "Compression format used sending records to an HTTP endpoint. Defaults to GZIP, use NONE to disable compression."
  type        = string
  default     = "GZIP"

  validation {
    condition     = can(regex("GZIP|NONE", var.http_endpoint_compression_format))
    error_message = "Valid values are GZIP or NONE."
  }
}

variable "s3_backup_mode" {
  description = "Determines how documents should be delivered to S3. Valid options are 'AllData' and 'FailedDataOnly' (default)."
  type        = string
  default     = "FailedDataOnly"

  validation {
    condition     = can(regex("AllData|FailedDataOnly", var.s3_backup_mode))
    error_message = "Valid values are AllData or FailedDataOnly."
  }
}

variable "s3_endpoint_bucket_arn" {
  description = "ARN of an S3 bucket to use as a destination"
  type        = string
}

variable "s3_endpoint_buffer_size_mb" {
  description = "Maxmimum size in megabytes to buffer before delivering to the S3 endpoint"
  type        = number
  default     = 4
}

variable "s3_endpoint_buffer_interval_seconds" {
  description = "Maximum number of seconds to buffer before delivering to the S3 endpoint"
  type        = number
  default     = 60
}

variable "s3_endpoint_compression_format" {
  description = "Compression format used when saving records to S3. Defaults to GZIP, also supports ZIP, Snappy, and HADOOP_SNAPPY. Use an empty string to disable compression."
  type        = string
  default     = "GZIP"

  validation {
    condition     = can(regex("^$|GZIP|ZIP|Snappy|HADOOP_SNAPPY", var.s3_endpoint_compression_format))
    error_message = "Valid values are GZIP, ZIP, Snappy, HADOOP_SNAPPY, or a blank string."
  }
}

variable "enable_cloudwatch_logs_delivery" {
  description = "Enable delivery of logs to CloudWatch."
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch Log Group Name that should be used to log items for this Delivery Stream. Required if enable_cloudwatch_logs_delivery is true."
  type        = string
  default     = null
}

variable "cloudwatch_log_stream_name" {
  description = "Name that should be used for the CloudWatch Log Stream containing delivery logs."
  type        = string
  default     = "HttpEndpointDelivery"
}

variable "s3_error_output_prefix" {
  description = "Prefix to add onto any records saved to S3 that fail delivery to the HTTP target."
  type        = string
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to the resources created by the module."
}

variable "consumer_role_arn" {
  description = "Role with the necessary policies to consume records from this Delivery Stream, send failed records to S3, and log messages to CloudWatch (if using enable_cloudwatch_logs_delivery)."
  type        = string
  default     = null
}
