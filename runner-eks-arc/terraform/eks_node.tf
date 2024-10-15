#-------------------------------------------------<EKS NODE GROUP>--------------------------------------------------
resource "aws_eks_node_group" "runner_node_1" {
  cluster_name    = aws_eks_cluster.runner_eks_cluster.name
  node_group_name = "node-group-1"
  node_role_arn   = aws_iam_role.eks_node_group_iam_role.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = var.node_instance_types
}
