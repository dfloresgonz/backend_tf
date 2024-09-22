# common.tf or shared module
locals {
  combined_integrations = var.integration_dependencies
}

resource "aws_api_gateway_deployment" "api_stage" {
  rest_api_id = var.rest_api_id
  stage_name  = "test"
  depends_on  = local.combined_integrations
}
