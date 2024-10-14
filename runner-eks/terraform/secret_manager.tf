resource "aws_secretsmanager_secret" "github_runner_secret" {
  name                    = "github-runner-creds"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "github_creds" {
  secret_id = aws_secretsmanager_secret.github_runner_secret.id
  secret_string = jsonencode({
    PAT = var.pat_token
  })
}
