
resource "helm_release" "github_runner" {
  name  = "github-runner"
  chart = "${path.module}/../github-runner-helm/"

  values = [templatefile("${path.module}/../github-runner-helm/values.tpl", {
    deployment_replicas               = 1
    container_image                   = aws_ecr_repository.runner_ecr.repository_url
    github_owner                      = "CloudOpsPioneer"
    github_repo                       = "terraform-aws-flaskapp"
    runner_labels                     = "dev,flask-app,eks,cicd"
    requests_cpu                      = "500m"
    requests_memory                   = "512Mi"
    limits_cpu                        = "1"
    limits_memory                     = "1Gi"
    service_account_name              = "github-runner-irsa"
    service_account_role_arn          = aws_iam_role.eks_runner_iam_role.arn
    hpa_min_replicas                  = 1
    hpa_max_replicas                  = 10
    target_cpu_utilization_percentage = 75
    secret_provider_region            = "us-east-1"
    aws_secret_name                   = "github-runner-creds"
    aws_secret_key                    = "PAT"
    kube_secret_name                  = "gh-runner-secret"
    kube_secret_key                   = "access_token"
  })]

  depends_on = [helm_release.csi_secrets_store, helm_release.secrets_provider_aws]
}
