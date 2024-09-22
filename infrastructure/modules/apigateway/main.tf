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
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.my_zone.zone_id
  records = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

resource "aws_api_gateway_domain_name" "custom_domain" {
  domain_name     = "api.decepticons.dev"
  certificate_arn = aws_acm_certificate.cert.arn
}

resource "aws_api_gateway_deployment" "api_stage" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "test"
  depends_on = [
    aws_api_gateway_integration.integration1,
    aws_api_gateway_integration.integration2,
  ]
}
