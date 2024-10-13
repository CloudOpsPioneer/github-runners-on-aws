/*
# Use this only if you don't use Secret CSI driver

resource "kubernetes_secret_v1" "github-runner_secret" {
  metadata {
    name = "gh-runner-secret"
  }

  data = {
    "access_token" = var.pat_token
  }
 depends_on = [aws_eks_node_group.runner_node_1]
}
*/



/*
# Yaml for Secret
# ---------------

apiVersion: v1
kind: Secret
metadata:
  name: gh-runner-secret
type: Opaque
data:
  access_token: YOUR_BASE64_ENCODED_PAT_TOKEN


# How to base64 encode
# --------------------
echo "<YOUR_PAT_TOKEN>" | base64

# kubectl cli for Secret
# -----------------------

kubectl create secret generic gh-runner-secret --from-literal access_token=<YOUR_PAT_TOKEN>
*/
