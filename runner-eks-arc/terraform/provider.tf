terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

data "aws_eks_cluster_auth" "runner_eks_cluster" {
  name = aws_eks_cluster.runner_eks_cluster.name
}

provider "kubernetes" {
  #config_path = "~/.kube/config"
  host                   = aws_eks_cluster.runner_eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.runner_eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.runner_eks_cluster.token
}
