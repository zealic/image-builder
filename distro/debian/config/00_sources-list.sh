cat > /etc/apt/sources.list <<EOF
deb http://${MIRROR_HOST}/debian/ bullseye main
deb-src http://${MIRROR_HOST}/debian/ bullseye main
deb http://${MIRROR_HOST}/debian/ bullseye-updates main
deb-src http://${MIRROR_HOST}/debian/ bullseye-updates main
deb http://${MIRROR_HOST}/debian-security/ bullseye/updates main
deb-src http://${MIRROR_HOST}/debian-security/ bullseye/updates main
EOF

apt-get update
