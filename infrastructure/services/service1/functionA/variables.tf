variable "aws_region" {
  description = "La región de AWS en la que se desplegarán los recursos"
  type        = string
}

variable "environment" {
  description = "Variables de entorno para la función Lambda"
  type        = string
}
