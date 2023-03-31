FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    sudo \
    openssh-server

# Install Docker CLI
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo \
      "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && \
    apt-get install -y nodejs

# Install Python
RUN apt-get install -y python3 python3-pip && \
    pip3 install --upgrade pip

# Create a non-root user and add it to the sudo group
ARG USERNAME=runneruser
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user to the non-root user
USER $USERNAME
ENV ORG=""
ENV TOKEN=""
ENV NAME=""

WORKDIR /runner
RUN curl -o actions-runner-linux-x64-2.298.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.298.0/actions-runner-linux-x64-2.298.0.tar.gz && \
    tar xzf ./actions-runner-linux-x64-2.298.0.tar.gz && \
    rm -f actions-runner-linux-x64-2.298.0.tar.gz

COPY ./setup.sh /runner/


ENTRYPOINT ["/runner/setup.sh", ORG , TOKEN, NAME]
