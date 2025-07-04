variable "project" {
  description = "Project name for tagging resources"
  type        = string
    default     = "roboshop1"
}

variable "environment" {
  description = "Environment for the VPC (e.g., dev, prod)"
  type        = string
  default = "dev"
}

variable "public_subnet_cidr" {
  description = "List of CIDR blocks to allow access"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnet_cidr" {
  description = "List of CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}