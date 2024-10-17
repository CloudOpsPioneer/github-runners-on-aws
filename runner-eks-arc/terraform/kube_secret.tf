data "aws_secretsmanager_secret_version" "github_runner_app_ids" {
  secret_id = aws_secretsmanager_secret.github_runner_app_ids.id
}

data "aws_secretsmanager_secret_version" "github_runner_pvt_key" {
  secret_id = aws_secretsmanager_secret.github_runner_pvt_key.id
}

locals {
  github_runner_app_ids = jsondecode(data.aws_secretsmanager_secret_version.github_runner_app_ids.secret_string)
  github_runner_pvt_key = data.aws_secretsmanager_secret_version.github_runner_pvt_key.secret_string
}

resource "kubernetes_secret_v1" "github_runner_secret" {
  metadata {
    name      = "gh-app-arc-runner-secret"
    namespace = "arc-runners"
  }

  data = {
    github_app_id              = local.github_runner_app_ids["github_app_id"]
    github_app_installation_id = local.github_runner_app_ids["github_app_installation_id"]
    github_app_private_key     = local.github_runner_pvt_key
  }
  depends_on = [aws_eks_node_group.runner_node_1, kubernetes_namespace_v1.arc_runners]
}

