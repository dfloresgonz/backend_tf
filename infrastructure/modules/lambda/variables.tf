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

variable "base_name" {
  description = "Nombre base para la función Lambda y otros recursos"
  type        = string
}

variable "handler_path" {
  description = "Ruta al archivo de entrada de la función Lambda"
  type        = string
}

variable "filename" {
  description = "Ruta al archivo ZIP de la función Lambda"
  type        = string
}
