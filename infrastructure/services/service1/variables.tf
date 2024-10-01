variable "api_name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "dominio" {
  description = "The domain name"
  type        = string
}

variable "region" {
  description = "The region where the resources will be created"
  type        = string
}

variable "runtime" {
  description = "The Node.js version for the Lambda function"
  type        = string
}

variable "stage" {
  description = "The stage of the API Gateway"
  type        = string
}

variable "USUARIO_BD" {
  description = "Usuario de la base de datos"
  type        = string
}

variable "TUPAY_API_KEY" {
  description = "API Key for the Tupay API"
  type        = string
}

variable "TUPAY_API_SIG" {
  description = "API Key signature for the Tupay API"
  type        = string
}
