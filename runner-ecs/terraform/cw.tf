#-------------------------------------------------<CW GROUP>--------------------------------------------------
resource "aws_cloudwatch_log_group" "gh_runner" {
  name              = "github-runner"
  retention_in_days = 1
}
