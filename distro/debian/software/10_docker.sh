# docker-compose
COMPOSE_VER=1.28.3
COMPOSE_URL=https://github.com/docker/compose/releases/download/${COMPOSE_VER}/docker-compose-Linux-x86_64
curl -sSL -o /usr/local/bin/docker-compose \
    "$COMPOSE_URL" \
    && chmod +x /usr/local/bin/docker-compose

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

cat > /etc/apt/sources.list.d/docker.list <<EOF
deb [arch=amd64] https://download.docker.com/linux/debian buster stable
EOF

# docker-ce
DOCKER_VER=20.10
apt-get update
apt-get install -yq --no-install-recommends docker-ce=5:${DOCKER_VER}.*

systemctl enable docker
