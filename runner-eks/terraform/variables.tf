variable "vpc_id" {
  type        = string
  default     = "vpc-xxxxxxx"
  description = "VPC ID"
}

variable "region" { default = "us-east-1" }

variable "node_instance_types" { default = ["t3.medium"] }

variable "private_subnet_ids" { default = ["subnet-xxxxxxxxx", "subnet-xxxxxxxxx"] }

variable "public_subnet_ids" { default = ["subnet-xxxxxxxxx"] }

variable "my_public_ip" {
  default     = "168.x.xx.x/32"
  description = "my public ip where i will hit the ALB DNS name"
}

variable "my_private_ip" {
  default     = "10.xx.xx.xx/32"
  description = "private ip of ec2 instance where i terraform and kubectl commands"

}


# Use variable only if you are not using Secret CSI driver and Secrets Manager. Uncomment kube_secret.tf, and comment the kube_secretproviderclass.tf and modify the kube_deployment.tf to remove volumemounts, volume and initContainer
#variable "pat_token" {}
