module "functionA" {
  source     = "./functionA.aux"
  aws_region = var.aws_region
  ENVIROMENT = var.ENVIROMENT
  USUARIO_BD = var.USUARIO_BD
}
module "common" {
  source      = "../../../modules/common"
  rest_api_id = module.functionA.api_gateway.my_api.id
  integration_dependencies = [
    module.functionA.integration1_id,
  ]
}
