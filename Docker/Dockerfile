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

# Instalar el runner de GitActions
RUN mkdir /actions-runner && cd /actions-runner && \
    curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/download/v2.298.0/actions-runner-linux-x64-2.298.0.tar.gz && \
    tar xzf actions-runner-linux-x64.tar.gz && \
    rm -f actions-runner-linux-x64.tar.gz && \
    ./bin/installdependencies.sh

# Instalar Docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh


# Copiar el script de inicio
COPY entrypoint.sh /actions-runner/entrypoint.sh
RUN chmod +x /actions-runner/entrypoint.sh

# Configurar usuario no-root
RUN useradd -m runner && \
    chown -R runner:runner /actions-runner/entrypoint.sh

# Cambiar al usuario no-root
USER runner

# Establecer el directorio de trabajo
WORKDIR /actions-runner

# Ejecutar el script de inicio
ENTRYPOINT ["/actions-runner/entrypoint.sh"]
