variable "region" {
  description = "La región de AWS en la que se desplegarán los recursos"
  type        = string
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

variable "variables" {
  description = "Variables de entorno para la función Lambda"
  type        = map(string)
}

variable "runtime" {
  description = "Versión de Node.js para la función Lambda"
  type        = string
}
