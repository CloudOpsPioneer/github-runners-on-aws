#----------------------------------------------------<AUTO SCALING GROUP>-----------------------------------------------------
resource "aws_appautoscaling_target" "ecs_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.gh_runner.name}/${aws_ecs_service.github_runner_svc.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 3
  max_capacity       = 5
}

resource "aws_appautoscaling_policy" "scale_out" {
  name               = "scale_out"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = 70.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
