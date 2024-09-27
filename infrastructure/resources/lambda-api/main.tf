provider "aws" {
  region = var.region
}

module "lambdaAPI" {
  source       = "../../modules/lambda"
  base_name    = "${var.api_name}-${var.function_name}"
  handler_path = "bundle.main"
  filename     = "deploy/${var.function_name}.zip"
  # filename     = "../../../services/${var.api_name}/${var.function_name}/lambda.zip"
  region    = var.region
  variables = var.variables
  runtime   = var.runtime
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = var.api_service_id
  parent_id   = var.root_resource_id
  path_part   = var.function_name
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = var.api_service_id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = var.api_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = var.api_service_id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${module.lambdaAPI.lambda_function_arn}/invocations"
}

resource "aws_lambda_permission" "api_gateway_function" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambdaAPI.name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${var.api_service_id}/*/*"
}
