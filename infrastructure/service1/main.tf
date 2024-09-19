terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
  # access_key = var.access_key
  # secret_key = var.secret_key
}

locals {
  service_name = "service1"
}

module "functionA" {
  source       = "../modules/lambda"
  base_name    = "${local.service_name}-functionA"
  handler_path = "bundle.main"
  filename     = "../../services/service1/functionA/lambda.zip"
  aws_region   = var.aws_region
  # access_key   = var.access_key
  # secret_key   = var.secret_key
}

output "functionA_arn" {
  value = module.functionA.lambda_function_arn
}
