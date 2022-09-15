variable "company" {
  default     = "ecr-cycloid"
}

variable "account_id" {
  default     = "[account id]"
}

variable "aws_access_key" {
  type    = string
  default = ""
}


variable "aws_secret_key" {
  type    = string
  default = ""
}
variable "aws_ecr_image_tag" {
  type    = string
  default = "wordpress"
}


variable "playbook_dir" {
  type    = string
  default = "../ansible/playbook.yml"
}
variable "ecr_login_server" {
  type    = string
  default = "[account id].dkr.ecr.us-east-1.amazonaws.com"
}