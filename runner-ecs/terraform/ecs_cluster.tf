#-------------------------------------------------<ECS CLUSTER>--------------------------------------------------
resource "aws_ecs_cluster" "gh_runner" {
  name = "github-runner-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
