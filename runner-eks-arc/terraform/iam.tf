#------------------------------------------------<EKS CLUSTER IAM ROLE>------------------------------------------------#
data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "amz_eks_cluster_policy" {
  name = "AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_cluster_iam_role" {
  name                = "github-runner-arc-eks-cluster-iam-role"
  assume_role_policy  = data.aws_iam_policy_document.eks_assume_role_policy.json
  managed_policy_arns = [data.aws_iam_policy.amz_eks_cluster_policy.arn]
}

#------------------------------------------------<EKS NODE GROUP IAM ROLE>------------------------------------------------#
data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


data "aws_iam_policy" "AmazonEKSWorkerNodePolicy" {
  name = "AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "AmazonEC2ContainerRegistryReadOnly" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}


data "aws_iam_policy" "AmazonEKS_CNI_Policy" { # was not able to create node group without this policy
  name = "AmazonEKS_CNI_Policy"
}

resource "aws_iam_role" "eks_node_group_iam_role" {
  name = "github-runner-arc-eks-node-group-iam-role"

  assume_role_policy  = data.aws_iam_policy_document.ec2_assume_role_policy.json
  managed_policy_arns = [data.aws_iam_policy.AmazonEKSWorkerNodePolicy.arn, data.aws_iam_policy.AmazonEC2ContainerRegistryReadOnly.arn, data.aws_iam_policy.AmazonEKS_CNI_Policy.arn]
}

