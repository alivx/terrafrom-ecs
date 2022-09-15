variable "company" {
  default     = "cycloid"
  description = "Name of the company as whitelist"
}

variable "account_id" {
  type        = string
  default     = "[accountID]"
  description = "AWS account ID"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR of the main VPC"
  default     = "10.0.0.0/16"
}

variable "regionA" {
  type        = string
  description = "AWS region"
  default     = "us-east-1a"
}
variable "regionA2" {
  type        = string
  description = "AWS region"
  default     = "us-east-1b"
}
variable "regionB" {
  type        = string
  description = "AWS region"
  default     = "us-east-1a"
}
variable "regionB2" {
  type        = string
  description = "AWS region"
  default     = "us-east-1b"
}

variable "public_subnets" {
  type        = string
  description = "CIDR of the public subnets"
  default     = "10.0.20.0/24"
}

variable "public_subnets2" {
  type        = string
  description = "CIDR of the public subnets"
  default     = "10.0.21.0/24"
}
variable "private_subnets" {
  type        = string
  description = "CIDR of the private subnets"
  default     = "10.0.10.0/24"
}

variable "private_subnets_dbA" {
  type        = string
  description = "CIDR of the private subnets"
  default     = "10.0.11.0/24"
}

variable "private_subnets_dbB" {
  type        = string
  description = "CIDR of the private subnets"
  default     = "10.0.12.0/24"
}

variable "ecs_cluster_count" {
  type    = number
  default = 1
}

variable "db_user" {
  type    = string
  default = "app"
}

variable "db_password" {
  type    = string
  default = "[password]"
}

variable "db_name" {
  type    = string
  default = "alidb"
}

variable "container_port" {
  type    = number
  default = 80
}
