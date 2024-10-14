#-------------------------------------------------<<<<<IGNORE THIS FILE>>>>>-------------------------------------------------
# Commented this since I converted the Manifest to helm chart. Refer https://github.com/karthikrajkkr/github-runners-on-aws/tree/main/runner-eks/github-runner-helm

/*
resource "kubernetes_manifest" "github_runner_creds" {
  manifest = {
    apiVersion = "secrets-store.csi.x-k8s.io/v1"
    kind       = "SecretProviderClass"
    metadata = {
      name      = "github-runner-creds"
      namespace = "default" #kubernetes_deployment_v1.github_runner.metadata[0].namespace
    }
    spec = {
      provider = "aws"
      parameters = {
        region  = "us-east-1"
        objects = <<-EOT
          - objectName: "${aws_secretsmanager_secret.github_runner_secret.name}"
            objectType: "secretsmanager"
            jmesPath:
              - path: "PAT"
                objectAlias: "PAT"
        EOT
      }
      secretObjects = [
        {
          secretName = "gh-runner-secret"
          type       = "Opaque"
          data = [
            {
              key        = "access_token"
              objectName = "PAT"
            },
          ]
        },
      ]
    }
  }
  depends_on = [helm_release.secrets_provider_aws]
}
*/
/*

#Yaml format of SecretProviderClass
#----------------------------------

apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: github-runner-creds
spec:
  provider: aws
  parameters:
    region: us-east-1
    objects: |
      - objectName: "github-runner-creds"
        objectType: "secretsmanager"
        jmesPath:
          - path: "PAT"
            objectAlias: "PAT"
  secretObjects: # This section syncs the data to a Kubernetes Secret
  - secretName: gh-runner-secret
    type: Opaque
    data:
    - key: access_token
      objectName: PAT

*/
