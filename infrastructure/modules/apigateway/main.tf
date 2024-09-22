resource "aws_api_gateway_rest_api" "my_api" {
  name = var.api_name
}

resource "aws_api_gateway_domain_name" "custom_domain" {
  domain_name     = "decepticons.dev"
  certificate_arn = aws_acm_certificate.cert.arn
}

resource "aws_api_gateway_deployment" "api_stage" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "test"
  depends_on  = var.integrations
}
