# common.tf or shared module
resource "aws_api_gateway_deployment" "api_stage" {
  rest_api_id = module.api_gateway.my_api.id
  stage_name  = "test"
  depends_on = [
    aws_api_gateway_integration.integration1,
    aws_api_gateway_integration.integration2,
  ]
}
