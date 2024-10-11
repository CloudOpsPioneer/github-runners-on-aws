
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
