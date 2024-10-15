ARG AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
# change the python release/download url down below when modifying the version here
ARG PYTHON=3.12.5 
ARG PYTHON_MAJOR_MINOR=3.12
ARG TERRAFORM=1.9.5

# https://github.com/actions/runner/blob/main/images/Dockerfile
FROM ghcr.io/actions/actions-runner:2.320.0 as build

ARG AGENT_TOOLSDIRECTORY
ARG PYTHON
ARG PYTHON_MAJOR_MINOR
ARG TERRAFORM

USER root

RUN mkdir -p $AGENT_TOOLSDIRECTORY
ENV AGENT_TOOLSDIRECTORY=$AGENT_TOOLSDIRECTORY

# vital_packages
RUN apt-get update -y && apt-get install -q -y bzip2 g++ gcc git jq make tar unzip unzip wget

# common_packages
RUN apt-get install -q -y apt-transport-https autoconf automake build-essential dbus dnsutils dpkg dpkg-dev amazon-ecr-credential-helper fakeroot fonts-noto-color-emoji gnupg2 iproute2 iputils-ping libtool libssl-dev locales mercurial openssh-client openssl p7zip-rar pkg-config python-is-python3 rpm software-properties-common texinfo tk tzdata upx xvfb xz-utils zsync

# cmd_packages
RUN apt-get install -q -y acl aria2 binutils bison brotli coreutils file findutils flex ftp gnupg haveged lz4 m4 mediainfo netcat net-tools p7zip-full parallel patchelf pigz pollinate rsync shellcheck sphinxsearch sqlite3 ssh sshpass sudo swig telnet time zip

# GitHub Cli
RUN mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update && apt-get install gh -y

# curl
RUN wget -q https://curl.se/download/curl-8.8.0.zip && unzip -q curl-8.8.0.zip && \
    cd curl-8.8.0 && ./configure --with-openssl && make && make -s install && ldconfig

# Python, Python3, pip, pip3
RUN mkdir -p /opt/hostedtoolcache/Python/${PYTHON}/x64/
RUN wget -q https://github.com/actions/python-versions/releases/download/${PYTHON}-10375840348/python-${PYTHON}-linux-22.04-x64.tar.gz
RUN tar -xzf python-${PYTHON}-linux-22.04-x64.tar.gz -C /opt/hostedtoolcache/Python/${PYTHON}/x64/
ENV PATH="${PATH}:/opt/hostedtoolcache/Python/${PYTHON}/x64/bin"
RUN ln -s -f /opt/hostedtoolcache/Python/${PYTHON}/x64/bin/pip${PYTHON_MAJOR_MINOR} /usr/local/bin/pip
RUN ln -s -f /opt/hostedtoolcache/Python/${PYTHON}/x64/bin/pip${PYTHON_MAJOR_MINOR} /usr/local/bin/pip3
RUN ln -s -f /opt/hostedtoolcache/Python/${PYTHON}/x64/bin/python${PYTHON_MAJOR_MINOR} /usr/local/bin/python
RUN ln -s -f /opt/hostedtoolcache/Python/${PYTHON}/x64/bin/python${PYTHON_MAJOR_MINOR} /usr/local/bin/python${PYTHON_MAJOR_MINOR}
RUN ln -s -f /opt/hostedtoolcache/Python/${PYTHON}/x64/bin/python3 /usr/local/bin/python3
RUN python -m pip -q install GitPython PyGithub ansible-core checkov tox ghapi jsonschema packaging pdm pdm-bump pep440 pytest pytest-playwright playwright pyyaml requests selenium semver tomli twine webdriver-manager wheel yamllint


# Terraform
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM}/terraform_${TERRAFORM}_linux_amd64.zip \
    && unzip -q terraform_${TERRAFORM}_linux_amd64.zip \
    && mv terraform /usr/local/bin \
    && rm -rf terraform_${TERRAFORM}_linux_amd64.zip

# AWS-tools
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&\
    unzip -q awscliv2.zip && ./aws/install
RUN wget -q https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip \
    && unzip -q aws-sam-cli-linux-x86_64.zip -d /tmp/sam-installation && /tmp/sam-installation/install

# yq
RUN wget -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq

# Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Helm
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash





FROM ghcr.io/actions/actions-runner:2.320.0
ARG AGENT_TOOLSDIRECTORY
ARG PYTHON
COPY --from=build /bin/ /bin/
COPY --from=build /etc/ /etc/
COPY --from=build /usr/ /usr/
COPY --from=build /opt/ /opt/
COPY --chown=runner:docker --from=build ${AGENT_TOOLSDIRECTORY} ${AGENT_TOOLSDIRECTORY}
ENV PATH="${PATH}:/home/runner/.local/bin:/usr/local/go/bin:${AGENT_TOOLSDIRECTORY}/Python/${PYTHON}/x64/bin"
ENV TZ="America/New_York"
WORKDIR /home/runner
