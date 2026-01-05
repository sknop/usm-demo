resource "confluent_service_account" "usm-manager" {
  display_name = "${var.usm-manager}-${var.username}"
  description  = "Service account to manage USM agents"
}

resource "confluent_role_binding" "usm-manager-usm-agent" {
  principal   = "User:${confluent_service_account.usm-manager.id}"
  role_name   = "UsmAgent"
  crn_pattern = confluent_environment.usm_environment.resource_name
}

resource "confluent_role_binding" "usm-manager-data-steward" {
  principal   = "User:${confluent_service_account.usm-manager.id}"
  role_name   = "DataSteward"
  crn_pattern = confluent_environment.usm_environment.resource_name
}

