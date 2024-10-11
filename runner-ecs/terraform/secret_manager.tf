
resource "aws_secretsmanager_secret" "github_runner_secret" {
  name = "github-runner-creds"
}

resource "aws_secretsmanager_secret_version" "github_creds" {
  secret_id = aws_secretsmanager_secret.github_runner_secret.id
  secret_string = jsonencode({
    PAT = ""                                                    # Update it post creation. Next terraform apply will not revert back to empty value. 
  })
}
