## Running on EKS

This folder walks through how you can deploy github self-hosted runners as pods on EKS with autoscaling.

- EKS infrastructure is deployed through terraform. You need to pass the PAT (Personal Access Token) token as a variable while running terraform apply.
  
  ```
terraform apply -var pat_token=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  ```
- The kubernetes objects created are Deployment that takes github details as env vars, HorizontalPodAutoscaler, IRSA (IAM Role as Service Account), and SecretProviderClass.
- All the Kube objects are created as custom helm charts, and the values are passed to the [values.tpl](https://github.com/karthikrajkkr/github-runners/blob/main/runner-eks/github-runner-helm/values.tpl) template file while running terraform apply.
- In short, AWS infrastructure is created through Terraform, where Kube objects are deployed through a helm chart that is installed through the Terraform `helm_release` resource.
![image](https://github.com/user-attachments/assets/e67bf585-05a2-4b21-a754-dae9b66086b5)
