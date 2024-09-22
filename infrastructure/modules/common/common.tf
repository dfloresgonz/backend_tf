# common.tf or shared module
resource "aws_api_gateway_deployment" "api_stage" {
  rest_api_id = var.rest_api_id
  stage_name  = "test"
  depends_on  = var.integration_dependencies
}
