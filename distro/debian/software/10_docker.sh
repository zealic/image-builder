# docker-compose
COMPOSE_VER=2.2.2
COMPOSE_URL=https://github.com/docker/compose/releases/download/v${COMPOSE_VER}/docker-compose-linuxa-x86_64
curl -sSL -o /usr/local/bin/docker-compose \
    "$COMPOSE_URL" \
    && chmod +x /usr/local/bin/docker-compose

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

cat > /etc/apt/sources.list.d/docker.list <<EOF
deb [arch=amd64] https://download.docker.com/linux/debian ${DEBIAN_CODENAME} stable
EOF

# docker-ce
DOCKER_VER=20.10
apt-get update
apt-get install -yq --no-install-recommends docker-ce=5:${DOCKER_VER}.*

if [[ "$DISTRO_SUFFIX" == "-cn" ]]; then
  mkdir -p /etc/docker
  cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": [
    "http://hub-mirror.c.163.com",
    "https://docker.mirrors.ustc.edu.cn"
  ]
}
EOF
fi

systemctl enable docker
