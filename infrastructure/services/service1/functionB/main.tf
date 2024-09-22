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
  function_name = "functionB"
}

module "functionB" {
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
}

resource "aws_api_gateway_resource" "resource2" {
  rest_api_id = module.api_gateway.my_api_id
  parent_id   = module.api_gateway.root_resource_id
  path_part   = "functionB"
}

resource "aws_api_gateway_method" "method2" {
  rest_api_id   = module.api_gateway.my_api_id
  resource_id   = aws_api_gateway_resource.resource2.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration2" {
  rest_api_id             = module.api_gateway.my_api_id
  resource_id             = aws_api_gateway_resource.resource2.id
  http_method             = aws_api_gateway_method.method2.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "GET"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${module.functionB.lambda_function_arn}/invocations"
}

resource "aws_api_gateway_base_path_mapping" "mapping2" {
  domain_name = module.api_gateway.custom_domain_name
  api_id      = module.api_gateway.my_api_id
  stage_name  = aws_api_gateway_deployment.api_stage.stage_name
  base_path   = local.service_name
}

resource "aws_api_gateway_deployment" "api_stage" {
  rest_api_id = module.api_gateway.my_api_id
  stage_name  = "test"
  depends_on = [
    aws_api_gateway_integration.integration2
  ]
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.functionB.name #  aws_lambda_function.functionA.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${module.api_gateway.my_api_id}/*/*"
}

data "aws_caller_identity" "current" {}
