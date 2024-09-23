resource "aws_api_gateway_rest_api" "my_api" {
  name = var.api_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "api.decepticons.dev"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "my_zone" {
  name         = "decepticons.dev."
  private_zone = false
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
  records         = [each.value.value] # Usa el valor de validación obtenido
  ttl             = 300
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "null_resource" "check_domain" {
  provisioner "local-exec" {
    command = <<EOT
      if aws apigateway get-domain-name --domain-name api.decepticons.dev --region ${var.aws_region}; then
        echo "exists" > ${path.module}/domain_check.txt
      else
        echo "not found" > ${path.module}/domain_check.txt
      fi
    EOT
    environment = {
      AWS_DEFAULT_REGION = var.aws_region
    }
    on_failure  = "continue"
    interpreter = ["bash", "-c"]
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

data "local_file" "domain_check" {
  filename = "${path.module}/domain_check.txt"
}

locals {
  create_domain = trim(data.local_file.domain_check.content, "\n") == "not found" ? 1 : 0
}

# data "aws_api_gateway_domain_name" "existing_domain" {
#   domain_name = "api.decepticons.dev"
# }
# locals {
#   domain_exists = try(data.aws_api_gateway_domain_name.existing_domain.id, "")
# }

# locals {
#   create_domain = local.domain_exists == "" ? 1 : 0
# }

resource "aws_api_gateway_domain_name" "custom_domain" {
  count = local.create_domain

  domain_name              = "api.decepticons.dev"
  regional_certificate_arn = aws_acm_certificate.cert.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_route53_record" "api_gateway_domain" {
  count = local.create_domain

  zone_id = data.aws_route53_zone.my_zone.zone_id
  name    = "api.decepticons.dev"
  type    = "CNAME"
  ttl     = 300
  records = [aws_api_gateway_domain_name.custom_domain[0].regional_domain_name]
}

output "my_api_id" {
  value = aws_api_gateway_rest_api.my_api.id
}

output "root_resource_id" {
  value = aws_api_gateway_rest_api.my_api.root_resource_id
}

output "custom_domain_name" {
  # value = aws_api_gateway_domain_name.custom_domain.domain_name
  value = local.create_domain == 1 ? aws_api_gateway_domain_name.custom_domain[0].domain_name : "api.decepticons.dev"
  # condition = aws_api_gateway_domain_name.custom_domain.count > 0
}

# resource "aws_api_gateway_deployment" "api_stage" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   stage_name  = "test"
#   depends_on = [
#     aws_api_gateway_integration.integration1,
#     aws_api_gateway_integration.integration2,
#   ]
# }
