#-------------------------------------------------<ECR>--------------------------------------------------
resource "aws_ecr_repository" "github_runner_ecr" {
  name                 = "github-runner-arc"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}
