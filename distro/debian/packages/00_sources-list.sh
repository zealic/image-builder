cat > /etc/apt/sources.list <<EOF
deb http://${MIRROR_HOST}/debian/ stretch main
deb-src http://${MIRROR_HOST}/debian/ stretch main
deb http://${MIRROR_HOST}/debian/ stretch-updates main
deb-src http://${MIRROR_HOST}/debian/ stretch-updates main
deb http://${MIRROR_HOST}/debian-security/ stretch/updates main
deb-src http://${MIRROR_HOST}/debian-security/ stretch/updates main
EOF
