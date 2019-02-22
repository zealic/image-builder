apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common || true

# docker-compose
COMPOSE_VER=1.23.2
curl -sSL -o /usr/local/bin/docker-compose \
    "https://github.com/docker/compose/releases/download/${COMPOSE_VER}/docker-compose-Linux-x86_64" \
    && chmod +x /usr/local/bin/docker-compose

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"

# docker-ce
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

systemctl enable docker
