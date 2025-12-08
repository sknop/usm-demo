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

resource "confluent_private_link_attachment" "pla" {
  cloud  = "AWS"
  region = var.region
  display_name = "usm-platt"
  environment {
    id = confluent_environment.usm_environment.id
  }
}

module "privatelink" {
  source                   = "./aws-privatelink-endpoint"
  vpc_id                   = aws_vpc.vpc.id
  privatelink_service_name = confluent_private_link_attachment.pla.aws[0].vpc_endpoint_service_name
  dns_domain               = confluent_private_link_attachment.pla.dns_domain
  subnets_to_privatelink   = local.subnets_to_privatelink
}

resource "confluent_private_link_attachment_connection" "plac" {
  display_name = "usm-aws-plattc"
  environment {
    id = confluent_environment.usm_environment.id
  }
  aws {
    vpc_endpoint_id = module.privatelink.vpc_endpoint_id
  }

  private_link_attachment {
    id = confluent_private_link_attachment.pla.id
  }
}

# Should not be necessary
# resource "confluent_kafka_cluster" "basic" {
#   display_name = "Basic Dummy"
#   availability = "SINGLE_ZONE"
#   cloud = "AWS"
#   region = var.region
#
#   basic {}
#
#   environment {
#     id = confluent_environment.usm_environment.id
#   }
# }
