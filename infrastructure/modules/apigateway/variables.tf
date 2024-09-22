variable "api_name" {
  type        = string
  description = "Nombre del API Gateway"
}

# variable "api_description" {
#   type        = string
#   description = "Descripción del API Gateway"
#   default     = "API Gateway to trigger Lambda"
# }

variable "path_part" {
  type        = string
  description = "Path para la API Gateway"
}

# variable "integrations" {
#   type        = list(any)
#   description = "Lista de integraciones para el despliegue"
# }

# variable "http_method" {
#   type        = string
#   description = "Método HTTP para la API Gateway"
#   default     = "POST"
# }

# variable "lambda_function_name" {
#   type        = string
#   description = "Nombre de la función Lambda"
# }

# variable "lambda_invoke_arn" {
#   type        = string
#   description = "ARN para invocar la función Lambda"
# }

# variable "stage_name" {
#   type        = string
#   description = "Nombre del stage para la API Gateway"
#   default     = "dev"
# }

# variable "region" {
#   type        = string
#   description = "Región de AWS"
# }
