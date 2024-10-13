resource "kubernetes_horizontal_pod_autoscaler" "github_runner_hpa" {
  metadata {
    name = "github-runner-hpa"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment_v1.github_runner.metadata[0].name
    }

    min_replicas = 1
    max_replicas = 10

    target_cpu_utilization_percentage = 75
  }

}


/*
#YAML format of HPA for better understanding
#-------------------------------------------
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: github-runner-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: github-runner
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 75
*/
