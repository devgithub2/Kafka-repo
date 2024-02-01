# variables.tf

variable "cloud_api_key" {
  description = "Confluent Cloud API Key"
}

variable "cloud_api_secret" {
  description = "Confluent Cloud API Secret"
}

variable "confluent_key" {
  description = "Confluent Kafka API Key"
}

variable "confluent_secret" {
  description = "Confluent Kafka API Secret"
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID for S3 Sink"
}

variable "aws_secret_access_key" {
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

