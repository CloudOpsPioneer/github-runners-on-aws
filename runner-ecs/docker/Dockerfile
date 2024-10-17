FROM ubuntu:20.04

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Runner Version
ARG RUNNER_VERSION="2.320.0"
ARG TERRAFORM=1.9.5

# Install necessary tools
RUN apt-get update     && apt-get install -y     curl     sudo     git     jq     build-essential   wget unzip  && rm -rf /var/lib/apt/lists/*

# Download and install the runner
RUN cd /home && mkdir actions-runner && cd actions-runner     && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz     && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz     && rm -f ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz     && ./bin/installdependencies.sh

# Create a runner user
RUN useradd -m runner -s /bin/bash     && chown -R runner:runner /home/actions-runner     && echo "runner ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER runner
WORKDIR /home/actions-runner


# Terraform
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM}/terraform_${TERRAFORM}_linux_amd64.zip \
    && unzip -q terraform_${TERRAFORM}_linux_amd64.zip \
    && sudo mv terraform /usr/local/bin \
    && rm -rf terraform_${TERRAFORM}_linux_amd64.zip

# AWS-tools
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&\
    unzip -q awscliv2.zip && sudo ./aws/install
RUN wget -q https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip \
    && unzip -q aws-sam-cli-linux-x86_64.zip -d /tmp/sam-installation && sudo /tmp/sam-installation/install



# Script to register & run the runner
COPY entrypoint.sh .
RUN sudo chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
