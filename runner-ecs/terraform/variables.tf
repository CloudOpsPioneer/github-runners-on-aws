
variable "vpc_id" {
  type = string
  #default     = "vpc-05b4f2e13b7df5467"
  default     = "vpc-01252ba88fe00818d"
  description = "VPC ID"
}

variable "private_subnet_id" {
  description = "private subnet id"
  default     = "subnet-042cbd3c7d727dc8e"
  #default     = "subnet-03639446afdabc019"
}

variable "region" {
  type    = string
  default = "us-east-1"
}
