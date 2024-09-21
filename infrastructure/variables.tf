variable "aws_region" {
  description = "La región de AWS en la que se desplegarán los recursos"
  type        = string
}

variable "access_key" {
  description = "La clave de acceso de AWS"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "La clave secreta de AWS"
  type        = string
  sensitive   = true
}

variable "ENVIRONMENT" {
  description = "Variables de entorno para la función Lambda"
  type        = string
}

variable "USUARIO_BD" {
  description = "Usuario de la base de datos"
  type        = string
}
