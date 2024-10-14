resource "null_resource" "update_kubeconfig" {
  depends_on = [aws_eks_node_group.runner_node_1]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.runner_eks_cluster.name}"
  }

}



# https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html
resource "null_resource" "apply_metrics_server" {

  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
  }

  depends_on = [aws_eks_node_group.runner_node_1, null_resource.update_kubeconfig]
}
