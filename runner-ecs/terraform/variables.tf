variable "vpc_id" {
  type = string
  default     = "vpc-05b4f2e13b7df5467"
  description = "VPC ID"
}

variable "private_subnet_id" {
  description = "private subnet id"
  default     = "subnet-03639446afdabc019"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

# pass while running tf apply ->  terraform apply -var pat_token=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
variable "pat_token" {}
