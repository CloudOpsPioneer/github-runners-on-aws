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
