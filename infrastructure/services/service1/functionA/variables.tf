variable "aws_region" {
  description = "La región de AWS en la que se desplegarán los recursos"
  type        = string
}

variable "ENVIROMENT" {
  description = "Variables de entorno para la función Lambda"
  type        = string
}

variable "USUARIO_BD" {
  description = "Usuario de la base de datos"
  type        = string
}
