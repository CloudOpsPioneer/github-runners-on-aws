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

#### Removing runner
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