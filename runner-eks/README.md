## Running on EKS

### Table of contents
1. [Overview](#Overview)<br>
2. [Naming convention of Runner](#Naming-convention-of-Runner)<br>
3. [Secret Maintenance](#secret-maintenance)<br>
4. [github-runner custom helm charts](#github-runner-custom-helm-charts)

### Overview
This folder walks through how you can deploy github self-hosted runners as pods on EKS with autoscaling.

- EKS infrastructure is deployed through terraform. You need to pass the PAT (Personal Access Token) token as a variable while running terraform apply.
  
  ```
terraform apply -var pat_token=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  ```
- The kubernetes objects created are Deployment that takes github details as env vars, HorizontalPodAutoscaler, IRSA (IAM Role as Service Account), and SecretProviderClass.
- All the Kube objects are created as custom helm charts, and the values are passed to the [values.tpl](https://github.com/karthikrajkkr/github-runners/blob/main/runner-eks/github-runner-helm/values.tpl) template file while running terraform apply.
- In short, AWS infrastructure is created through Terraform, where Kube objects are deployed through a helm chart that is installed through the Terraform `helm_release` resource.

### Naming convention of Runner
The format of runner name is combination of pod name created through deployment and the node name where the pod is placed: <POD_NAME>-<NODE_NAME>.
It is defined in [entrypoint.sh](https://github.com/karthikrajkkr/github-runners-on-aws/blob/main/runner-eks/docker/entrypoint.sh)
![image](https://github.com/user-attachments/assets/e67bf585-05a2-4b21-a754-dae9b66086b5)

### Secret Maintenance
- You can use either Kube-secret or AWS Secret Manager for your local testing.
- It is recommended to use AWS Secret Manager in production for better security.
- The below AWS documentation and blog post explain how you can configure the Secret CSI driver in EKS and integrate the pods with AWS Secret Manager. <br>
https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_csi_driver.html<br>
https://aws.amazon.com/blogs/security/how-to-use-aws-secrets-configuration-provider-with-kubernetes-secrets-store-csi-driver/
- You need to install two things before proceeding - (a) Secrets Store CSI Driver (b) AWS Secrets and Configuration Provider (ASCP). The above AWS documentation page has the instructions to install them manually through helm commands. In this repo, I have implemented through Terraform `helm_release` instead of the manual method. Refer to the file [helm_secret_csi.tf] (https://github.com/karthikrajkkr/github-runners-on-aws/blob/main/runner-eks/terraform/helm_secret_csi.tf)
- Below are the manual installation steps I have done to test before converting them to Terraform. This is only to compare the helm through CLI and Terraform.
```
# Manual installation - Secrets Store CSI Driver
# ----------------------------------------------
# Add the Helm repository for the CSI Secrets Store
# helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts

# If you want to list the repos and list all the versions of a repo
# helm repo list
# helm search repo secrets-store-csi-driver --versions

# Install the Helm chart
# helm upgrade --install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver     --namespace kube-system     --version 1.4.6     --set syncSecret.enabled=true     --set enableSecretRotation=true     --set rotationPollInterval=2h
```

```
# Manual installation - AWS Secrets and Configuration Provider
# ------------------------------------------------------------
# Add the Helm repository for the AWS secrets provider
# helm repo add secrets-provider-aws https://aws.github.io/secrets-store-csi-driver-provider-aws

# If you want to list the repos and list all the versions of a repo
# helm repo list
# helm search repo secrets-provider-aws --versions

# Install the Helm chart
# helm upgrade --install secrets-provider-aws secrets-provider-aws/secrets-store-csi-driver-provider-aws     --namespace kube-system     --version 0.3.9
```

### github-runner custom helm charts
- Initially, I have created all the Kube objects through Terraform resources. It is correct too, but I want to implement through helm, so I have converted it into helm charts. You can notice most of the kube_*.tf files are commented.
- Using the below commands, I created the charts, customized them, and installed them. In case of deployment, I deleted and recreated it.
```
helm create github-runner
helm install my-release ./github-runner/
helm delete my-release
```
- I am not following any versioning of charts as of now. Explore the  folder [github-runner-helm](https://github.com/karthikrajkkr/github-runners-on-aws/tree/main/runner-eks/github-runner-helm) for more details.
- I tested the manual helm install by using [values.yaml](https://github.com/karthikrajkkr/github-runners-on-aws/blob/main/runner-eks/github-runner-helm/values.yaml) file in that folder by hard coding the values required for manifest files.
- Later, I converted it into a template file and passed the values through Terraform Resource. Refer to [helm_github_runner.tf](https://github.com/karthikrajkkr/github-runners-on-aws/blob/main/runner-eks/terraform/helm_github_runner.tf) to see how I am passing to the template file.
