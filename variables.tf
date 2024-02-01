

variable "cloud_api_key" {
  type = string
  description = "Confluent Cloud API Key"
}

variable "cloud_api_secret" {
  type = string
  description = "Confluent Cloud API Secret"
}

variable "confluent_key" {
  type = string
  description = "Confluent Kafka API Key"
}

variable "confluent_secret" {
  type = string
  description = "Confluent Kafka API Secret"
}

variable "aws_access_key_id" {
  type = string
  description = "AWS Access Key ID for S3 Sink"
}

variable "aws_secret_access_key" {
  type = string
  description = "AWS Secret Access Key for S3 Sink"
}

variable "region" {
  description = "AWS Region for the Confluent Kafka Cluster"
  default     = "us-east-2"
}

variable "s3_bucket_name" {
  description = "S3 Bucket Name for Sink Connector"
  default     = "data-from-kafka-conf"
}

variable "confluent_credentials" {
  description = "Confluent credentials for ACLs and connectors"
  type = object({
    key    = string
    secret = string
  })
  default = {
    key    = ""
    secret = ""
  }
}

