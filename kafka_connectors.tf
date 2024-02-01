
resource "confluent_connector" "source" {
  environment {
    id = confluent_environment.Testing.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  config_sensitive = {}

  config_nonsensitive = {
    "connector.class"          = "DatagenSource"
    "name"                     = "DatagenSourceConnector_0"
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = "sa-xwy06q"
    "kafka.topic"              = "orders"
    "output.data.format"       = "JSON"
    "quickstart"               = "ORDERS"
    "tasks.max"                = "1"
  }
  depends_on = [
    confluent_kafka_acl.app-connector-describe-on-cluster,
    confluent_kafka_acl.app-connector-write-on-target-topic,
    confluent_kafka_acl.app-connector-create-on-data-preview-topics,
    confluent_kafka_acl.app-connector-write-on-data-preview-topics,
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_connector" "sink" {
  environment {
    id = confluent_environment.Testing.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  config_sensitive = {
    "aws.access.key.id"     = "AKIA42AMBBFXVZEELBF4"
    "aws.secret.access.key" = "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"
  }

  config_nonsensitive = {
    "topics"                   = "orders"
    "input.data.format"        = "JSON"
    "connector.class"          = "S3_SINK"
    "name"                     = "S3_SINKConnector_23"
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = "sa-xwy06q"
    "s3.bucket.name"           = "data-from-kafka-confi"  // Ensure this bucket exists in the us-east-2 region
    "output.data.format"       = "JSON"
    "time.interval"            = "DAILY"
    "flush.size"               = "1000"
    "tasks.max"                = "1"
  }

  lifecycle {
    prevent_destroy = true
  }
}


resource "confluent_kafka_acl" "describe-basic-cluster" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:sa-xyz123"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = "https://pkc-921jm.us-east-2.aws.confluent.cloud:443"
  credentials {
    key    = var.confluent_key
    secret = var.confluent_secret
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_kafka_acl" "app-connector-describe-on-cluster" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:sa-xwy06q"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = "https://pkc-921jm.us-east-2.aws.confluent.cloud:443"
  credentials {
    key    = var.confluent_key
    secret = var.confluent_secret
  }
}

resource "confluent_kafka_acl" "app-connector-write-on-target-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  resource_type = "TOPIC"
  resource_name = "orders"
  pattern_type  = "LITERAL"
  principal     = "User:sa-xwy06q"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = "https://pkc-921jm.us-east-2.aws.confluent.cloud:443"
  credentials {
    key    = var.confluent_key
    secret = var.confluent_secret
  }
}

resource "confluent_kafka_acl" "app-connector-create-on-data-preview-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  resource_type = "TOPIC"
  resource_name = "data-preview" // Adjust if you have a specific topic name pattern for data preview
  pattern_type  = "PREFIXED"
  principal     = "User:sa-xwy06q"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = "https://pkc-921jm.us-east-2.aws.confluent.cloud:443"
  credentials {
    key    = var.confluent_key
    secret = var.confluent_secret
  }
}

resource "confluent_kafka_acl" "app-connector-write-on-data-preview-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  resource_type = "TOPIC"
  resource_name = "data-preview" // Adjust if you have a specific topic name pattern for data preview
  pattern_type  = "PREFIXED"
  principal     = "User:sa-xwy06q"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = "https://pkc-921jm.us-east-2.aws.confluent.cloud:443"
  credentials {
    key    = var.confluent_key
    secret = var.confluent_secret
  }
}

resource "confluent_kafka_acl" "sink-connector-read-on-orders" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  resource_type = "TOPIC"
  resource_name = "orders"
  pattern_type  = "LITERAL"
  principal     = "User:sa-xwy06q"  // Ensure this matches the service account used by the sink connector
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = "https://pkc-921jm.us-east-2.aws.confluent.cloud:443"
  credentials {
    key    = var.confluent_key
    secret = var.confluent_secret
  }
}

resource "confluent_kafka_acl" "dlq-create" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  resource_type = "TOPIC"
  resource_name = "dlq-lcc" // This is a prefix for the topic
  pattern_type  = "PREFIXED"
  principal     = "User:sa-xwy06q"  // Ensure this matches the service account used by the sink connector
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = "https://pkc-921jm.us-east-2.aws.confluent.cloud:443"
  credentials {
    key    = var.confluent_key
    secret = var.confluent_secret
  }
}

resource "confluent_kafka_acl" "dlq-write" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  resource_type = "TOPIC"
  resource_name = "dlq-lcc" // This is a prefix for the topic
  pattern_type  = "PREFIXED"
  principal     = "User:sa-xwy06q"  // Ensure this matches the service account used by the sink connector
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = "https://pkc-921jm.us-east-2.aws.confluent.cloud:443"
  credentials {
    key    = var.confluent_key
    secret = var.confluent_secret
  }
}

resource "confluent_kafka_acl" "consumer-group-read" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  resource_type = "GROUP"
  resource_name = "connect-lcc-" // This is a prefix for the consumer group
  pattern_type  = "PREFIXED"
  principal     = "User:sa-xwy06q"  // Ensure this matches the service account used by the sink connector
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = "https://pkc-921jm.us-east-2.aws.confluent.cloud:443"
  credentials {
    key    = var.confluent_key
    secret = var.confluent_secret
  }
}

resource "confluent_kafka_acl" "consumer-group-describe" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  resource_type = "GROUP"
  resource_name = "connect-lcc-" // This is a prefix for the consumer group
  pattern_type  = "PREFIXED"
  principal     = "User:sa-xwy06q"  // Ensure this matches the service account used by the sink connector
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = "https://pkc-921jm.us-east-2.aws.confluent.cloud:443"
  credentials {
    key    = var.confluent_key
    secret = var.confluent_secret
  }
}

resource "confluent_kafka_acl" "consumer-group-delete" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  resource_type = "GROUP"
  resource_name = "connect-lcc-" // This is a prefix for the consumer group
  pattern_type  = "PREFIXED"
  principal     = "User:sa-xwy06q"  // Ensure this matches the service account used by the sink connector
  host          = "*"
  operation     = "DELETE"
  permission    = "ALLOW"
  rest_endpoint = "https://pkc-921jm.us-east-2.aws.confluent.cloud:443"
  credentials {
    key    = var.confluent_key
    secret = var.confluent_secret
  }
}

