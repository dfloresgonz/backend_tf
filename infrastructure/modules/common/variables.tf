variable "integration_dependencies" {
  type        = list(any)
  description = "Lista de integraciones para el despliegue"
}

variable "rest_api_id" {
  type        = string
  description = "ID del API Gateway"
}
