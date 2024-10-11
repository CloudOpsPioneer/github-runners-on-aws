data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

#------------------------------------------------<EXECUTION IAM ROLE>------------------------------------------------#

data "aws_iam_policy_document" "secret_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [aws_secretsmanager_secret.github_runner_secret.arn]
  }
}

data "aws_iam_policy" "amz_ecs_exec_policy" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_exec_iam_role" {
  name                = "github-runner-task-exec-iam-role"
  assume_role_policy  = data.aws_iam_policy_document.ecs_assume_role_policy.json
  managed_policy_arns = [data.aws_iam_policy.amz_ecs_exec_policy.arn]

  inline_policy {
    name   = "secrets-manager-policy"
    policy = data.aws_iam_policy_document.secret_policy.json
  }

}

#------------------------------------------------<TASK IAM ROLE>------------------------------------------------#

# policy to run ecs exec
data "aws_iam_policy" "amz_ecs_ssm_policy" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "task_iam_role" {
  name                = "github-runner-task-iam-role"
  assume_role_policy  = data.aws_iam_policy_document.ecs_assume_role_policy.json
  managed_policy_arns = [data.aws_iam_policy.amz_ecs_ssm_policy.arn]
}
