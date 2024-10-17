resource "kubernetes_namespace_v1" "arc_runners" {
  metadata {
    name = "arc-runners"
  }
  depends_on = [aws_eks_node_group.runner_node_1]
}


/*
#YAML format of Namespace for better understanding
#----------------------------------------------------------
apiVersion: v1
kind: Namespace
metadata:
  name: arc-runners
*/