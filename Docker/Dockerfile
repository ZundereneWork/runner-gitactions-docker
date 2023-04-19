FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    sudo \
    openssh-server


# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && \
    apt-get install -y nodejs

# Install Python
RUN apt-get install -y python3 python3-pip && \
    pip3 install --upgrade pip

# Instalar dependencias para Docker
RUN apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Descargar e instalar Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce


# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install powerShell and Az cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb |  bash

RUN wget -q 'https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb'
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update 
RUN apt-get install -y powershell

RUN pwsh -command "& {Install-Module -Name Az -AllowClobber -Scope AllUsers -Force}" \
    && pwsh -command "& {Install-Module -Name Pester -Scope AllUsers -Force}" \
    && pwsh -command "& {Install-Module -Name Az.Subscription -Scope AllUsers -AllowPrerelease -Force}" \ 
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python3 /usr/bin/python

# Instalar el runner de GitActions
RUN mkdir /actions-runner && cd /actions-runner && \
    curl -o actions-runner-linux-x64-2.303.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.303.0/actions-runner-linux-x64-2.303.0.tar.gz && \
    tar xzf actions-runner-linux-x64-2.303.0.tar.gz && \
    rm -f actions-runner-linux-x64-2.303.0.tar.gz && \
    ./bin/installdependencies.sh


ADD entrypoint.sh  /actions-runner/entrypoint.sh

RUN chmod +x /actions-runner/entrypoint.sh
RUN chown -R 1001:123 /actions-runner/entrypoint.sh

# Configurar usuario no-root
RUN useradd -m runner && \
    chown -R runner:runner /actions-runner

# Agregar grupo y usuario 'docker'
#RUN groupadd -g 999 docker && useradd -r -u 999 -g docker docker


# Instala Docker dentro del contenedor
#RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
RUN usermod -aG docker runner
RUN newgrp docker

# Cambiar al usuario no-root
USER runner

ENV DOCKER_HOST=unix:///run/user/1001/docker.sock

# Establecer el directorio de trabajo
WORKDIR /actions-runner


# Ejecutar el script de inicio
ENTRYPOINT ["./entrypoint.sh"]
