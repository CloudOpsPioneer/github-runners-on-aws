resource "aws_secretsmanager_secret" "github_runner_app_ids" {
  name                    = "github-runner-arc-app-ids"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "github_runner_app_ids" {
  secret_id = aws_secretsmanager_secret.github_runner_app_ids.id
  secret_string = jsonencode({
    github_app_id              = ""
    github_app_installation_id = ""
  })
}


resource "aws_secretsmanager_secret" "github_runner_pvt_key" {
  name                    = "github-runner-arc-app-pvt-key"
  recovery_window_in_days = 0
}

