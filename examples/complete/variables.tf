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

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object(
    {
      name       = string
      max_length = optional(number, 60)
    }
  ))
  default = {
    log_group = {
      name       = "lg"
      max_length = 60
    }
    delivery_stream = {
      name       = "ds"
      max_length = 60
    }
    s3 = {
      name       = "s3"
      max_length = 63
    }
    subscription_filter = {
      name       = "sub-fltr"
      max_length = 60
    }
    consumer_policy = {
      name       = "cnsmr-plcy"
      max_length = 60
    }
    consumer_role = {
      name       = "cnsmr-role"
      max_length = 60
    }
    producer_policy = {
      name       = "prdcr-plcy"
      max_length = 60
    }
    producer_role = {
      name       = "prdcr-role"
      max_length = 60
    }
  }
}

variable "naming_prefix" {
  description = "Prefix for the provisioned resources."
  type        = string
  default     = "platform"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  default     = "000"
}

variable "region" {
  description = "AWS Region in which the infra needs to be provisioned"
  default     = "us-east-2"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  default     = "000"
}

variable "http_endpoint_url" {
  description = "URL to which the Delivery Stream should deliver its records."
  type        = string
}

variable "http_endpoint_name" {
  description = "Friendly name for the HTTP endpoint associated with this Delivery Stream."
  type        = string
}

variable "consumer_trusted_services" {
  description = "Trusted service used for the assumption policy when creating the consumer role. Defaults to the firehose service."
  type        = string
  default     = null
}

variable "consumer_external_id" {
  description = "STS External ID used for the assumption policy when creating the consumer role. Defaults to the current AWS account ID."
  type        = string
  default     = null
}

variable "producer_trusted_services" {
  description = "Trusted service used for the assumption policy when creating the producer role. Defaults to the logs service for the current AWS region."
  type        = string
  default     = null
}

variable "producer_external_id" {
  description = "STS External ID used for the assumption policy when creating the producer role."
  type        = list(string)
  default     = null
}

variable "s3_error_prefix" {
  description = "Prefix to prepend to failed records being sent to S3. Ensure this value contains a trailing slash if set to anything other than an empty string."
  type        = string
  default     = ""
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to the resources created by the module."
}
