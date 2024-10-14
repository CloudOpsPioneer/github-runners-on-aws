# References
# https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_csi_driver.html
# https://aws.amazon.com/blogs/security/how-to-use-aws-secrets-configuration-provider-with-kubernetes-secrets-store-csi-driver/


#-------------------------------------------------<helm secrets-store-csi-driver-provider-aws>--------------------------------------------------
resource "helm_release" "csi_secrets_store" {
  name       = "csi-secrets-store"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  version    = "1.4.6" # Specify the version you want, check for the latest version in the Helm chart repository

  set {
    name  = "syncSecret.enabled"
    value = "true"
  }

  set {
    name  = "enableSecretRotation"
    value = "true"
  }

  set {
    name  = "rotationPollInterval"
    value = "2h"
  }


  depends_on = [aws_eks_node_group.runner_node_1]
}


# Manual installation
# -------------------
# Add the Helm repository for the CSI Secrets Store
# helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts

# Update your repositories
# helm repo update

# Install the Helm chart
# helm upgrade --install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver     --namespace kube-system     --version 1.4.6     --set syncSecret.enabled=true     --set enableSecretRotation=true     --set rotationPollInterval=2h

#-------------------------------------------------<helm secrets-store-csi-driver-provider-aws>--------------------------------------------------
resource "helm_release" "secrets_provider_aws" {
  name       = "secrets-provider-aws"
  namespace  = "kube-system"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  version    = "0.3.9" # Specify the version you want, check for the latest version in the Helm chart repository

  depends_on = [aws_eks_node_group.runner_node_1]
}

# Manual installation
# -------------------
# Add the Helm repository for the AWS secrets provider
# helm repo add secrets-provider-aws https://aws.github.io/secrets-store-csi-driver-provider-aws

# Update your repositories
# helm repo update

# Install the Helm chart
# helm upgrade --install secrets-provider-aws secrets-provider-aws/secrets-store-csi-driver-provider-aws     --namespace kube-system     --version 0.3.9
