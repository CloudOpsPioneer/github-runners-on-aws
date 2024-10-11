#-------------------------------------------------<ECS SERVICE>--------------------------------------------------
resource "aws_ecs_service" "github_runner_svc" {
  name            = "github-runner-svc"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.gh_runner.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 2

  network_configuration {
    subnets          = [var.private_subnet_id]
    security_groups  = [aws_security_group.ecs_svc_sg.id]
    assign_public_ip = true

    # Note : If you are using PUBLIC SUBNET, make sure to set [assign_public_ip = true]. Else you will see the below error when task tries to run

    #Set this to true if using public subnet. Else you will see -> ResourceInitializationError: unable to pull secrets or
    #registry auth: The task cannot pull registry auth from Amazon ECR: There is a connection issue between the task 
    #and Amazon ECR. Check your task network configuration. RequestError: send request failed caused by: 
    #Post "https://api.ecr.us-east-1.amazonaws.com/": dial tcp 44.213.79.50:443: i/o timeout

    # Doesn't matter if you are using PRIVATE SUBNET

  }

  enable_execute_command = true
}
