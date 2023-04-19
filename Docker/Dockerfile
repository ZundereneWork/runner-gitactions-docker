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

RUN echo en_US.UTF-8 UTF-8 >> /etc/locale.gen \
  && apt-get update \
  && apt-get install -y --no-install-recommends gnupg \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${GIT_CORE_PPA_KEY} \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    gnupg \
    lsb-release \
    curl \
    tar \
    unzip \
    zip \
    apt-transport-https \
    ca-certificates \
    sudo \
    gpg-agent \
    software-properties-common \
    build-essential \
    zlib1g-dev \
    zstd \
    gettext \
    libcurl4-openssl-dev \
    inetutils-ping \
    jq \
    wget \
    dirmngr \
    openssh-client \
    locales \
    python3-pip \
    python3-setuptools \
    python3 \
    dumb-init \
    nodejs \
    rsync \
    gosu \
  && DPKG_ARCH="$(dpkg --print-architecture)" \
  && LSB_RELEASE_CODENAME="$(lsb_release --codename | cut -f2)" \
  && sed -e 's/Defaults.*env_reset/Defaults env_keep = "HTTP_PROXY HTTPS_PROXY NO_PROXY FTP_PROXY http_proxy https_proxy no_proxy ftp_proxy"/' -i /etc/sudoers \
  && echo deb http://ppa.launchpad.net/git-core/ppa/ubuntu $([[ $(grep -E '^ID=' /etc/os-release | sed 's/.*=//g') == "ubuntu" ]] && (grep VERSION_CODENAME /etc/os-release | sed 's/.*=//g') || echo bionic) main>/etc/apt/sources.list.d/git-core.list \
  && apt-get update \
  && ( apt-get install -y --no-install-recommends git || apt-get install -t stable -y --no-install-recommends git || apt-get install -y --no-install-recommends git=1:2.33.1-0ppa1~ubuntu18.04.1 git-man=1:2.33.1-0ppa1~ubuntu18.04.1 ) \
  && ( [[ $(apt-cache search -n liblttng-ust0 | awk '{print $1}') == "liblttng-ust0" ]] && apt-get install -y --no-install-recommends liblttng-ust0 || : ) \
  && ( [[ $(apt-cache search -n liblttng-ust1 | awk '{print $1}') == "liblttng-ust1" ]] && apt-get install -y --no-install-recommends liblttng-ust1 || : ) \
  && ( ( curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip" && unzip awscliv2.zip -d /tmp/ && /tmp/aws/install && rm awscliv2.zip) || pip3 install --no-cache-dir awscli ) \
  && ( curl -s "https://github.com/git-lfs/git-lfs/releases/download/v${GIT_LFS_VERSION}/git-lfs-linux-${DPKG_ARCH}-v${GIT_LFS_VERSION}.tar.gz" -L -o /tmp/lfs.tar.gz && tar -xzf /tmp/lfs.tar.gz -C /tmp && /tmp/git-lfs-${GIT_LFS_VERSION}/install.sh && rm -rf /tmp/lfs.tar.gz  /tmp/git-lfs-${GIT_LFS_VERSION}) \
  && distro=$(lsb_release -is | awk '{print tolower($0)}') \
  && mkdir -p /etc/apt/keyrings \
  && ( curl -fsSL https://download.docker.com/linux/${distro}/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg ) \
  && version=$(lsb_release -cs | sed 's/bookworm\|n\/a/bullseye/g') \
  && ( echo "deb [arch=${DPKG_ARCH} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${distro} ${version} stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null ) \
  && apt-get update \
  && apt-get install -y docker-ce docker-ce-cli docker-buildx-plugin containerd.io docker-compose-plugin --no-install-recommends --allow-unauthenticated \
  && echo -e '#!/usr/bin/sh\ndocker compose --compatibility "$@"' > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose \
  && ( [[ "${LSB_RELEASE_CODENAME}" == "focal" ]] && ( echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /" | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list && curl -L "https://build.opensuse.org/projects/devel:kubic/public_key" | apt-key add -; echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /" | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list && curl -L "https://build.opensuse.org/projects/devel:kubic/public_key" | apt-key add - && apt-get update) || : ) \
  && ( [[ "${LSB_RELEASE_CODENAME}" == "focal" || "${LSB_RELEASE_CODENAME}" == "jammy" || "${LSB_RELEASE_CODENAME}" == "sid" || "${LSB_RELEASE_CODENAME}" == "bullseye" ]] && apt-get install -y --no-install-recommends podman buildah skopeo || : ) \
  && ( [[ "${LSB_RELEASE_CODENAME}" == "jammy" ]] && echo "Ubuntu Jammy is marked as beta. Please see https://github.com/actions/virtual-environments/issues/5490" || : ) \
  && GH_CLI_VERSION=$(curl -sL -H "Accept: application/vnd.github+json"   https://api.github.com/repos/cli/cli/releases/latest | jq -r '.tag_name' | sed 's/^v//g') \
  && GH_CLI_DOWNLOAD_URL=$(curl -sL -H "Accept: application/vnd.github+json"   https://api.github.com/repos/cli/cli/releases/latest | jq ".assets[] | select(.name == \"gh_${GH_CLI_VERSION}_linux_${DPKG_ARCH}.deb\")" | jq -r '.browser_download_url') \
  && curl -sSLo /tmp/ghcli.deb ${GH_CLI_DOWNLOAD_URL} && apt-get -y install /tmp/ghcli.deb && rm /tmp/ghcli.deb \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && groupadd -g 121 runner \
  && useradd -mr -d /home/runner -u 1001 -g 121 runner \
  && usermod -aG sudo runner \
  && usermod -aG docker runner \
  && echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers


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
