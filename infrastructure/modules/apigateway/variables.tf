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

variable "aws_region" {
  type        = string
  description = "La región de AWS en la que se desplegarán los recursos"
}
