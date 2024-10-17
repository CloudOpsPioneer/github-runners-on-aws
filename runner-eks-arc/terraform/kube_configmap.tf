#------------------------------------------------<KUBE CM AWS-AUTH>------------------------------------------------#

# Controlling permissions of kube api by adding/removing roles in aws-auth

resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<-EOT
      - groups:
          - "system:bootstrappers"
          - "system:nodes"
        rolearn: "${aws_iam_role.eks_node_group_iam_role.arn}"
        username: "system:node:{{EC2PrivateDNSName}}"
    EOT
  }

  force      = true
  depends_on = [aws_eks_node_group.runner_node_1, null_resource.update_kubeconfig]
}


/*
#YAML format of aws-auth ConfigMap for better understanding
#----------------------------------------------------------
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::1xxxxxxxxxxx9:role/github-runner-eks-node-group-iam-role
      username: system:node:{{EC2PrivateDNSName}}
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
*/
