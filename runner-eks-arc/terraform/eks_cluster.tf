#-------------------------------------------------<EKS CLUSTER>--------------------------------------------------
resource "aws_eks_cluster" "runner_eks_cluster" {
  name     = "github-runner-arc-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_iam_role.arn #or use existing default role --> eksClusterRole

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = [var.my_public_ip] # public ips from where you will run kubectl commands
    security_group_ids      = [aws_security_group.eks_sg.id]
  }

  access_config {
    authentication_mode                         = "CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

}



