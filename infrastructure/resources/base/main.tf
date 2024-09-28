terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.26"
    }
  }

  backend "s3" {}

  required_version = ">= 1.2.0"
}
# Especificar el proveedor
provider "aws" {
  region = var.region
}

locals {
  api_domain = "api.${var.dominio}"
}

############################ Hosted zone
data "aws_route53_zone" "my_zone" {
  name         = "${var.dominio}."
  private_zone = false
}

############################ Certificado
resource "aws_acm_certificate" "cert" {
  domain_name       = local.api_domain
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  name            = each.value.name
  type            = each.value.type
  zone_id         = data.aws_route53_zone.my_zone.zone_id
  records         = [each.value.value]
  ttl             = 300
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

############################ Custom domain
resource "aws_api_gateway_domain_name" "custom_domain" {
  domain_name              = local.api_domain
  regional_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

############################ api record
resource "aws_route53_record" "api_gateway_domain" {
  zone_id = data.aws_route53_zone.my_zone.zone_id
  name    = local.api_domain
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.custom_domain.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.custom_domain.regional_zone_id
    evaluate_target_health = false
  }
}

# Define the S3 bucket resource
resource "aws_s3_bucket" "tfstate" {
  bucket = var.tfstate_bucket

  tags = {
    Name        = "Terraform State Bucket"
    Environment = var.stage
  }
}
