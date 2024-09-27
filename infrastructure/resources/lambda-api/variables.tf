variable "region" {
  description = "AWS region"
}

variable "api_name" {
  description = "API name"
}

variable "variables" {
  description = "Variables de entorno para la función Lambda"
  type        = map(string)
}

variable "function_name" {
  description = "Function names"
  type        = string
}

variable "api_method" {
  description = "get / post / put / delete"
  type        = string
}

variable "api_service_id" {
  description = "API service id"
  type        = string
}

variable "account_id" {
  description = "AWS account id"
  type        = string
}

variable "root_resource_id" {
  description = "Root resource id"
  type        = string
}

variable "runtime" {
  description = "Node.js version"
  type        = string
}
