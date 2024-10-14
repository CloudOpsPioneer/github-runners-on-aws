##  Running on ECS
Refer the folder [runner-ecs](https://github.com/karthikrajkkr/github-runners-on-aws/tree/main/runner-ecs) for the implementation through terraform. You can set the desired count, min & max with autoscaling.

- Install the Terraform, docker on your local environment. Update the vpc_id, subnet_id as per your account.
- Run the terraform init, plan and apply to provision the infrastructure.
- The naming convention followed here is <RUNNER_PREFIX>-runner-<ECS_TASK_ID>-<TIMESTAMP>. Check [here](https://github.com/karthikrajkkr/github-runners-on-aws/blob/852c0767b8a3a0781d0d24c9c64297ae76514574/runner-ecs/docker/entrypoint.sh#L18-L21) for more information.
![image](https://github.com/user-attachments/assets/a01ac439-a502-43ba-b718-f2fe72c86ce1)
- Store your PAT after creating a secret manager. [This](https://github.com/karthikrajkkr/github-runners-on-aws/blob/852c0767b8a3a0781d0d24c9c64297ae76514574/runner-ecs/terraform/secret_manager.tf#L9) will create empty PAT key in the secret manager.
- One problem is that if the ECS task terminates for any reason, the runner will be available in the repo. You have to remove manually. I tried checking if we can remove runner after the container terminates, but I am not able to achieve it yet.
- To enter into the ECS container,use the below CLI command. We already enabled the ecs exec in the terraform code.
```sh
aws ecs execute-command   --region us-east-1   --cluster <ECS_CLUSTER_NAME>   --task <ECS_TASK_ID>   --container <CONTAINER_NAME>   --command "/bin/bash"   --interactive
```
Refer below if you face any issues about in executing the CLI.<br>
https://docs.aws.amazon.com/systems-manager/latest/userguide/install-plugin-linux.html<br>
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html<br>
https://repost.aws/knowledge-center/ecs-error-execute-command<br>
https://github.com/aws-containers/amazon-ecs-exec-checker