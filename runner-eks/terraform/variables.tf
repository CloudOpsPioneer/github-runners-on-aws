variable "vpc_id" {
  type        = string
  default     = "vpc-01252ba88fe00818d"
  description = "VPC ID"
}

variable "region" { default = "us-east-1" }

variable "node_instance_types" { default = ["t3.medium"] }

variable "private_subnet_ids" { default = ["subnet-042cbd3c7d727dc8e", "subnet-06028d1ac9f5b8b43"] }

variable "public_subnet_ids" { default = ["subnet-02ebe2419302c27b2"] }

variable "my_public_ip" {
  default     = "168.161.22.1/32"
  description = "my public ip where i will hit the ALB DNS name"
}

variable "my_private_ip" {
  default     = "10.74.49.137/32"
  description = "private ip of ec2 instance where i terraform and kubectl commands"

}

variable "pat_token" {}

