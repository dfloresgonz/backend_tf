# common.tf or shared module

locals {
  combined_integrations = merge(module.api_gateway.integrations,
    [{ "integration1" = aws_api_gateway_integration.integration1 },
      { "integration2" = aws_api_gateway_integration.integration2 }
    ]
  )
}

resource "aws_api_gateway_deployment" "api_stage" {
  rest_api_id = module.api_gateway.my_api.id
  stage_name  = "test"
  depends_on  = local.combined_integrations
}
