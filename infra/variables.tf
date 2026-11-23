variable "region" {
  description = "Región de AWS donde viviría la app"
  type        = string
  default     = "us-east-1"
}

variable "ambiente" {
  description = "Ambiente del despliegue"
  type        = string
  default     = "staging"
}

variable "vpc_id" {
  description = "VPC existente donde van la app y la base de datos"
  type        = string
  default     = "vpc-0a1b2c3d4e5f60789"
}

variable "subnet_privada_id" {
  description = "Subred privada para el servidor web"
  type        = string
  default     = "subnet-0a1b2c3d4e5f60789"
}

variable "db_subnet_group" {
  description = "Grupo de subredes privadas para RDS"
  type        = string
  default     = "taskapi-db-subnets"
}

variable "ami_id" {
  description = "AMI de Ubuntu 24.04 para el servidor web"
  type        = string
  default     = "ami-0e2c8caa4b6378d8c"
}
