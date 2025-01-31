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

output "arn" {
  description = "The ARN of the delivery streams."
  value       = aws_kinesis_firehose_delivery_stream.delivery_stream.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_kinesis_firehose_delivery_stream.delivery_stream.tags_all
}

output "name" {
  description = "The name of the delivery stream"
  value       = aws_kinesis_firehose_delivery_stream.delivery_stream.name
}

output "destination_id" {
  description = "The name of the delivery stream"
  value       = aws_kinesis_firehose_delivery_stream.delivery_stream.destination_id
}
