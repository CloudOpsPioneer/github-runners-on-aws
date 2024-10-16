locals {
  arc_chart_version = "0.9.3"
}

resource "helm_release" "arc" {
  name       = "arc"
  namespace  = "arc-systems"
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart      = "gha-runner-scale-set-controller"
  version    = local.arc_chart_version

  create_namespace = true

}

output "helm_arc_status" {
  value = helm_release.arc.status
}




resource "helm_release" "arc_runner_set" {
  name       = "arc-runner-set"
  chart      = "gha-runner-scale-set"
  namespace  = "arc-runners"
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  version    = local.arc_chart_version

  create_namespace = true

  set {
    name  = "minRunners"
    value = 1
  }

  set {
    name  = "maxRunners"
    value = 30
  }


  set {
    name  = "githubConfigUrl"
    value = "https://github.com/CloudOpsPioneer"
  }

  set_sensitive {
    name  = "githubConfigSecret.github_token"
    value = var.pat_token
  }

  set {
    name  = "runnerScaleSetName"
    value = "cloudops-github-runner"
  }


  set {
    name  = "template.spec.containers[0].image"
    value = aws_ecr_repository.github_runner_ecr.repository_url
  }


  values = [
    file("${path.module}/scaleSetValues.yaml")
  ]


}


output "helm_runnerset_status" {
  value = helm_release.arc_runner_set.status
}

