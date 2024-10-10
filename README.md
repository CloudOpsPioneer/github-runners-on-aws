# github-runners

This repo is to explore the different ways of creating Github runners and documenting it. 

## Running locally on EC2 instance
This method is pretty straight forward. Provision an EC2 instance of your choice. You can get all the commands from the Github console.
- Navigate to `Github repo > Settings >'Actions' on left plane > Runners > New self-hosted runner`
- Select the Runner image as `Linux`. Select Architecture as `x64` if you have provisioned the EC2 instance with Amazon Linux default ami. AMI name will also have this information if you have already provisioned EC2.
  
![image](https://github.com/user-attachments/assets/06d9698b-b93d-4425-8503-6ca21e7ab0a3)
- Copy and run the commands given in the console.
Install the below packages on your EC2 before running the given commands.
```
sudo yum install perl -y
sudo yum install libicu -y
```

Downloading the necessary files
```sh
# Create a folder
$ mkdir actions-runner && cd actions-runner

# Download the latest runner package
$ curl -o actions-runner-linux-x64-2.320.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-linux-x64-2.320.0.tar.gz

# Optional: Validate the hash
$ echo "93ac1b7ce743ee85b5d386f5c1787385ef07b3d7c728ff66ce0d3813d5f46900  actions-runner-linux-x64-2.320.0.tar.gz" | shasum -a 256 -c

# Extract the installer
$ tar xzf ./actions-runner-linux-x64-2.320.0.tar.gz
```
Configure
```
# Create the runner and start the configuration experience
$ ./config.sh --url https://github.com/your-username/your-repo --token YOUR_TOKEN_HERE

# Last step, run it!
$ ./run.sh
```
Note: While running the config.sh commands, it will prompt for typing in few details such as 
- Runner group - If you don't have Runner group set already, just press enter key to add the runner to Default group
- name of the runner
- labels — one or more comma-separated labels. This will help to choose the correct runner when there are multiple runners configured. You will mention this label in your workflows.
- work folder - The work folder, often referred to as '_work' by default, is a directory within the runner's installation path that hosts all the job execution content. 



##  Running as a service on EC2 instance
With this method, you can run the github runner as a daemon process. This is almost similar to the previous one, except creating a service file and running as a service. 
- Follow the steps for everything you have done in the previous step, except the execution of `./run.sh`.
- Create a `github-runner.service` by running the below command.
```
sudo vi /etc/systemd/system/github-runner.service
```
- Paste the below content into the file. Please change the path of ExecStart, User, and Working Directory accordingly. The path is where you followed the previous steps, and user is your current Linux user where you are performing the operations.
```
[Unit]
Description=GitHub Actions Runner
After=network.target

[Service]
ExecStart=/home/ec2-user/actions-runner/run.sh
User=ec2-user
WorkingDirectory=/home/ec2-user/actions-runner
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```
- Enable and start the service.
```
sudo systemctl enable github-runner
sudo systemctl daemon-reload
sudo systemctl start github-runner
```
- To confirm that the runner is working, you can check the status of the systemd service.
```
sudo systemctl status github-runner
```
- If the service is not running, check the logs by running the below command
```
journalctl -u github-runner
```

### Removing runner
If you want to remove the runner, 
- stop the service by running
  
```
sudo systemctl stop github-runner
```
- Navigate to the Runners in the repo and click on the below option to get the removal command.
  
![image](https://github.com/user-attachments/assets/ef5dfd15-c4b7-4fc0-b094-61866cf22fa7)

- Go to the working directory on your Linux machine, and run the command.
```
./config.sh remove --token YOUR_TOKEN_HERE
```
