resource "confluent_kafka_topic" "orders" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  topic_name    = "orders"
  rest_endpoint = "https://pkc-921jm.us-east-2.aws.confluent.cloud:443"

  credentials {
    key    = var.confluent_key
    secret = var.confluent_secret
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_kafka_topic" "ordersss" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  topic_name    = "confluent.kafka"
  rest_endpoint = "https://pkc-921jm.us-east-2.aws.confluent.cloud:443"

  credentials {
    key    = var.confluent_key
    secret = var.confluent_secret
  }

  lifecycle {
    prevent_destroy = true
  }
}

