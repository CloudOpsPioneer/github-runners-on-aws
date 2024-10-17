## Running on EKS using ARC(Action Runner Controller)


### Authentication
Authenitcation can be done through two ways as given in the official documentation. Refer the [authenticating-to-the-github-api](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/authenticating-to-the-github-api).

#### Using Github App(Recommended)
- Create a GitHub app and get the AppId, InstallationId and PrivateKey. Follow the step-by-step instructions to configure the GitHub app.
- I am creating two AWS secret Managers. One for storing the AppId, InstallationId in one Secret Manager,  and PrivateKey in a separate Secret Manager. This is because, the private key is not being retrieved in correct format when creating a Kube Secret. This is causing issues while running ARC Controller.
- Refer the files [secret_manager.tf ](https://github.com/CloudOpsPioneer/github-runners-on-aws/blob/main/runner-eks-arc/terraform/secret_manager.tf), [kube_secret.tf](https://github.com/CloudOpsPioneer/github-runners-on-aws/blob/main/runner-eks-arc/terraform/kube_secret.tf).
- Also, set the Kube secret name as input to the helm chart -> [helm_arc.tf](https://github.com/CloudOpsPioneer/github-runners-on-aws/blob/main/runner-eks-arc/terraform/helm_arc.tf)
```terraform
  set {
    name  = "githubConfigSecret"
    value = kubernetes_secret_v1.github_runner_secret.metadata.0.name
  }
```
- values file in the chart of the [gha-runner-scale-set-controller](https://github.com/actions/actions-runner-controller/blob/master/charts/gha-runner-scale-set/values.yaml) will have  default values set. Modify according to your needs by maintaining them in your local, and pass it to the helm_release resource as given in the  [helm_arc.tf](https://github.com/CloudOpsPioneer/github-runners-on-aws/blob/main/runner-eks-arc/terraform/helm_arc.tf).
  
```terraform
  values = [
    file("${path.module}/helm_values/scaleSetValues.yaml")
  ]
```
Uncomment&Comment the  sections below in the file.
```yaml
#githubConfigSecret:
#  github_token: ""

githubConfigSecret: pre-defined-secret
```
#### Using PAT(Personal Access Token)
- create a PAT by following the documentation.
- Modify the local values file([scaleSetValues.yaml](https://github.com/CloudOpsPioneer/github-runners-on-aws/blob/main/runner-eks-arc/terraform/helm_values/scaleSetValues.yaml)) accordingly. Uncomment&Comment the  sections below in the file.

```yaml
githubConfigSecret:
  github_token: ""

#githubConfigSecret: pre-defined-secret
```

- set the Kube secret name as input to the helm chart -> [helm_arc.tf](https://github.com/CloudOpsPioneer/github-runners-on-aws/blob/main/runner-eks-arc/terraform/helm_arc.tf)
  
```terraform
 set_sensitive {
    name  = "githubConfigSecret.github_token"
     value = var.pat_token
    }
```
- You need to pass the PAT (Personal Access Token) token as a variable while running terraform apply.<br>
  `terraform apply -var pat_token=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

