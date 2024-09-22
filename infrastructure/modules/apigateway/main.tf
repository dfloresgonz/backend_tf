resource "aws_api_gateway_rest_api" "my_api" {
  name = var.api_name
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "api.decepticons.dev"
  validation_method = "DNS" # O puede ser "EMAIL", según tu preferencia

  # Configurar los nombres alternativos si tienes subdominios
  # subject_alternative_names = ["www.mydomain.com"]

  # Las zonas de validación DNS deben configurarse si eliges la validación por DNS
  lifecycle {
    create_before_destroy = true
  }
}

# Obtener la zona DNS de Route 53 para realizar la validación por DNS
data "aws_route53_zone" "my_zone" {
  name         = "decepticons.dev."
  private_zone = false
}

# Validar el certificado por DNS (necesitarás agregar un registro CNAME en tu dominio)
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

resource "aws_api_gateway_domain_name" "custom_domain" {
  domain_name     = "api.decepticons.dev"
  certificate_arn = aws_acm_certificate.cert.arn
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

output "my_api_id" {
  value = aws_api_gateway_rest_api.my_api.id
}

output "root_resource_id" {
  value = aws_api_gateway_rest_api.my_api.root_resource_id
}

output "custom_domain_name" {
  value = aws_api_gateway_domain_name.custom_domain.domain_name
}

# resource "aws_api_gateway_deployment" "api_stage" {
#   rest_api_id = aws_api_gateway_rest_api.my_api.id
#   stage_name  = "test"
#   depends_on = [
#     aws_api_gateway_integration.integration1,
#     aws_api_gateway_integration.integration2,
#   ]
# }
