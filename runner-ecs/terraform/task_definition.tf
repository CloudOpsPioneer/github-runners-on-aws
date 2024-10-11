
resource "aws_ecs_task_definition" "task" {
  family                   = "github-runner-td"
  execution_role_arn       = aws_iam_role.task_exec_iam_role.arn
  task_role_arn            = aws_iam_role.task_iam_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "runner"
      image     = "${aws_ecr_repository.gh_runner.repository_url}:latest"
      essential = true
      environment = [
        { name = "GITHUB_OWNER", value = "karthikrajkkr" },
        { name = "GITHUB_REPO", value = "flaskapp-on-aws" },
        { name = "RUNNER_PREFIX", value = "flaskapp" },
        { name = "RUNNER_LABELS", value = "dev,flask-app,cicd" }
      ]
      secrets = [
        {
          name      = "PAT"
          valueFrom = "${aws_secretsmanager_secret.github_runner_secret.arn}:PAT::"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.gh_runner.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
      linuxParameters = {
        initProcessEnabled = true      # option to enable ecs exec
      }
    }
  ])

}
