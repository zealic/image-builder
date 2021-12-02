cat > /etc/apt/sources.list <<EOF
deb http://${DEBIAN_MIRROR}/debian/ ${DEBIAN_CODENAME} main
deb-src http://${DEBIAN_MIRROR}/debian/ ${DEBIAN_CODENAME} main
deb http://${DEBIAN_MIRROR}/debian/ ${DEBIAN_CODENAME}-updates main
deb-src http://${DEBIAN_MIRROR}/debian/ ${DEBIAN_CODENAME}-updates main
EOF

apt-get update
