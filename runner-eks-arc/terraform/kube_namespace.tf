resource "kubernetes_namespace_v1" "arc_runners" {
  metadata {
    name = "arc-runners"
  }
  depends_on = [aws_eks_node_group.runner_node_1]
}
