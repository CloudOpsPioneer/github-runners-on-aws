#-------------------------------------------------<ECR>--------------------------------------------------
resource "aws_ecr_repository" "gh_runner" {
  name                 = "github-runner"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}
