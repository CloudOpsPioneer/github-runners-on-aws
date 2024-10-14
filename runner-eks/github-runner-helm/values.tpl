deployment:
  replicas: ${deployment_replicas}
  container:
    image: "${container_image}"
  env:
    GITHUB_OWNER: "${github_owner}"
    GITHUB_REPO: "${github_repo}"
    RUNNER_LABELS: "${runner_labels}"
  resources:
    requests:
      cpu: "${requests_cpu}"
      memory: "${requests_memory}"
    limits:
      cpu: "${limits_cpu}"
      memory: "${limits_memory}"

serviceAccount:
  name: "${service_account_name}"
  roleArn: "${service_account_role_arn}"

hpa:
  minReplicas: ${hpa_min_replicas}
  maxReplicas: ${hpa_max_replicas}
  targetCpuUtilizationPercentage: ${target_cpu_utilization_percentage}

secretProviderClass:
  provider: aws
  region: "${secret_provider_region}"
  awsSecretName: "${aws_secret_name}"
  awsSecretKey: "${aws_secret_key}"
  kubeSecretName: "${kube_secret_name}"
  kubeSecretKey: "${kube_secret_key}"
