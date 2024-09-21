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

# output "functionA_arn" {
#   value = module.functionA.lambda_function_arn
# }
