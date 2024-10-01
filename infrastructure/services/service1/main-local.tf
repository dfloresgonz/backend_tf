provider "aws" {
  region = var.region
  endpoints {
    apigateway     = "http://localhost:4566"
    apigatewayv2   = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://s3.localhost.localstack.cloud:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
    acm            = "http://localhost:4566"
  }
}

resource "aws_api_gateway_rest_api" "API_service1" {
  name = var.api_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

####
data "aws_api_gateway_domain_name" "custom_domain" {
  domain_name = "api.${var.dominio}"
}

data "aws_caller_identity" "current" {}

locals {
  stage = var.stage
  variables = {
    ENVIROMENT = local.stage
    USUARIO_BD = var.USUARIO_BD
    API_KEY    = var.API_KEY
  }

  function_configs = {
    functionA = {
      api_method = "POST"
    }
    functionB = {
      api_method = "GET"
    }
    functionC = {
      api_method = "GET"
    }
    functionD = {
      api_method = "GET"
    }
    functionE = {
      api_method = "GET"
    }
    functionF = {
      api_method = "GET"
    }
    functionG = {
      api_method = "GET"
    }
    functionH = {
      api_method = "GET"
    }
    functionI = {
      api_method = "GET"
    }
  }
}

############################ Functions
module "funciones" {
  for_each = local.function_configs

  source           = "../../resources/lambda-api"
  api_name         = var.api_name
  function_name    = each.key
  api_method       = each.value.api_method
  runtime          = var.runtime
  api_service_id   = aws_api_gateway_rest_api.API_service1.id
  account_id       = data.aws_caller_identity.current.account_id
  root_resource_id = aws_api_gateway_rest_api.API_service1.root_resource_id
  region           = var.region
  variables        = local.variables
  # variables        = merge(local.variables, {
  #   NEW_VARIABLE1 = "value1"
  #   NEW_VARIABLE2 = "value2"
  # })
}

############################
############################
############################
############################
############################ Deployment y Stage
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id       = aws_api_gateway_rest_api.API_service1.id
  description       = "Deployment for the API"
  stage_description = "Deployed at ${timestamp()}"
  triggers = {
    redeployment = timestamp()
    timestamp    = timestamp()
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    module.funciones["functionA"].method,
    module.funciones["functionA"].integration,
    module.funciones["functionB"].method,
    module.funciones["functionB"].integration,
    module.funciones["functionC"].method,
    module.funciones["functionC"].integration,
    module.funciones["functionD"].method,
    module.funciones["functionD"].integration,
    module.funciones["functionE"].method,
    module.funciones["functionE"].integration,
    module.funciones["functionF"].method,
    module.funciones["functionF"].integration,
    module.funciones["functionG"].method,
    module.funciones["functionG"].integration,
    module.funciones["functionH"].method,
    module.funciones["functionH"].integration,
    module.funciones["functionI"].method,
    module.funciones["functionI"].integration
  ]
}

resource "aws_api_gateway_stage" "api_stage" {
  rest_api_id   = aws_api_gateway_rest_api.API_service1.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  stage_name    = local.stage
  description   = "Stage Deployed at: ${timestamp()}"
}

resource "aws_api_gateway_base_path_mapping" "mapping1" {
  domain_name = data.aws_api_gateway_domain_name.custom_domain.domain_name
  api_id      = aws_api_gateway_rest_api.API_service1.id
  stage_name  = aws_api_gateway_stage.api_stage.stage_name
  base_path   = var.api_name
}
