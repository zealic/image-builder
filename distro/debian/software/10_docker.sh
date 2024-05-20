###########################################################
# docker-compose
###########################################################
COMPOSE_VER=2.27.0
COMPOSE_URL=https://github.com/docker/compose/releases/download/v${COMPOSE_VER}/docker-compose-linux-x86_64
curl -sSL -o /usr/local/bin/docker-compose "$COMPOSE_URL" \
    && chmod +x /usr/local/bin/docker-compose
# cli-plugins support，eg: `docker compose`
mkdir -p /usr/local/lib/docker/cli-plugins
cp /usr/local/bin/docker-compose  /usr/local/lib/docker/cli-plugins/

###########################################################
# docker-ce
###########################################################
DOCKER_VER=26.1
# Add Docker's official GPG key:
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$DEBIAN_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -yq --no-install-recommends docker-ce=5:${DOCKER_VER}.*

if [[ "$DISTRO_SUFFIX" == "-cn" ]]; then
  mkdir -p /etc/docker
  cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn"
  ]
}
EOF
fi

systemctl enable docker
