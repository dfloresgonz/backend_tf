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

provider "aws" {
  region = var.aws_region
}

locals {
  service_name  = "service1"
  function_name = "functionA"
}

module "functionA" {
  source       = "../../../modules/lambda"
  base_name    = "${local.service_name}-${local.function_name}"
  handler_path = "bundle.main"
  filename     = "../../../../services/${local.service_name}/${local.function_name}/lambda.zip"
  aws_region   = var.aws_region
  variables = {
    ENVIROMENT = var.ENVIROMENT
    USUARIO_BD = var.USUARIO_BD
  }
}

module "api_gateway" {
  source = "../../../modules/apigateway"
  # aws_region = var.aws_region
  api_name  = "my_api"
  path_part = "service1"
  # integrations = local.combined_integrations
}

resource "aws_api_gateway_resource" "resource1" {
  rest_api_id = module.api_gateway.my_api_id
  parent_id   = module.api_gateway.root_resource_id
  path_part   = "functionA"
}

resource "aws_api_gateway_method" "method1" {
  rest_api_id   = module.api_gateway.my_api_id
  resource_id   = aws_api_gateway_resource.resource1.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration1" {
  rest_api_id             = module.api_gateway.my_api_id
  resource_id             = aws_api_gateway_resource.resource1.id
  http_method             = aws_api_gateway_method.method1.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = module.functionA.lambda_function_arn
}

resource "aws_api_gateway_base_path_mapping" "mapping1" {
  domain_name = module.api_gateway.custom_domain_name
  api_id      = module.api_gateway.my_api_id
  stage_name  = aws_api_gateway_deployment.api_stage.stage_name
  base_path   = "v1/service1"
}

# output "integration1_id" {
#   value = aws_api_gateway_integration.integration1.id
# }

resource "aws_api_gateway_deployment" "api_stage" {
  rest_api_id = module.api_gateway.my_api_id
  stage_name  = "test"
  depends_on = [
    aws_api_gateway_integration.integration1
  ]
}
