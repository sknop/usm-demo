provider "confluent" {
  cloud_api_key    = var.confluent_api_key
  cloud_api_secret = var.confluent_api_secret
}

resource "confluent_environment" "usm_environment" {
  display_name = "USM-${var.username}"

  stream_governance {
    package = "ADVANCED"
  }
}
