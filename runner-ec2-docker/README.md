##  Running as a docker container on EC2 instance
To run the github runner as a container, you need to have docker installed and running as a service. 

- Install docker
```sh
sudo yum install docker -y
sudo chmod 777 /var/run/docker.sock
sudo systemctl restart docker
```
- PAT (Personal Access Token) to authenticate to Github repos. It should have scope `repo` and `admin:org`
  ![image](https://github.com/user-attachments/assets/501c6bb1-3581-4162-9e11-a656b42febbc)

  
- Create a directory and place a Dockerfile and entrypoint.sh file
```
actions-runner-docker/
├── Dockerfile
└── entrypoint.sh
```
###### Dockerfile
```dockerfile
FROM ubuntu:20.04

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Runner Version
ARG RUNNER_VERSION="2.320.0"

# Install necessary tools
RUN apt-get update     && apt-get install -y     curl     sudo     git     jq     build-essential     && rm -rf /var/lib/apt/lists/*

# Download and install the runner
RUN cd /home && mkdir actions-runner && cd actions-runner     && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz     && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz     && rm -f ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz     && ./bin/installdependencies.sh

# Create a runner user
RUN useradd -m runner -s /bin/bash     && chown -R runner:runner /home/actions-runner     && echo "runner ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER runner
WORKDIR /home/actions-runner

# Script to register & run the runner
COPY entrypoint.sh .
RUN sudo chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
```
###### entrypoint.sh
```sh
#!/bin/bash

# Check if the PAT is available
if [ -z "$PAT" ]; then
  echo "Personal Access Token not provided. Set the PAT environment variable."
  exit 1
fi

# Fetch the runner token from GitHub API
REGISTRATION_TOKEN=$(curl -sX POST -H "Authorization: token $PAT" "https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/runners/registration-token" | jq -r '.token')

# Exit if unable to fetch token
if [ -z "$REGISTRATION_TOKEN" ]; then
  echo "Failed to fetch registration token"
  exit 1
fi

# Configure the GitHub Actions Runner
echo "Registering the GitHub Runner..."
./config.sh --url "https://github.com/${GITHUB_OWNER}/${GITHUB_REPO}" \
            --token "$REGISTRATION_TOKEN" \
            --name "$RUNNER_NAME" \
            --labels "$RUNNER_LABELS" \
            --unattended --replace
echo "Runner registered successfully."

# Run the GitHub Actions Runner
echo "Starting GitHub Runner..."
exec "./run.sh"
```
- Build the image and run as a container. You can pass the repo details and creds as envrionment variables
```sh
cd actions-runner-docker/
docker build . -t github-runner
docker run -d --name <CONTAINER_NAME> -e PAT='<PERSONAL_ACCESS_TOKEN>' -e GITHUB_OWNER='<GITHUB_OWNER>' -e GITHUB_REPO='<GITHUB_REPO>' -e RUNNER_NAME='<RUNNER_NAME>' -e RUNNER_LABELS="<LABELS FOR RUNNER-COMMA SEPARATED>" <IMAGE_NAME>

# Example: 
docker run -d --name github-runner -e PAT='ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' -e GITHUB_OWNER='karthikrajkkr' -e GITHUB_REPO='flaskapp-on-aws' -e RUNNER_NAME='flaskapp-runner' -e RUNNER_LABELS="dev,flask-app,cicd" github-runner
```