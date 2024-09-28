variable "region" {
  description = "AWS region"
}

variable "dominio" {
  description = "Dominio principal"
}

variable "tfstate_bucket" {
  description = "Bucket para almacenar el tfstate"
}

variable "stage" {
  description = "Stage del ambiente"
}
