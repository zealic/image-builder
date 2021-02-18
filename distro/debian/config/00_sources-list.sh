cat > /etc/apt/sources.list <<EOF
deb http://${MIRROR_HOST}/debian/ buster main
deb-src http://${MIRROR_HOST}/debian/ buster main
deb http://${MIRROR_HOST}/debian/ buster-updates main
deb-src http://${MIRROR_HOST}/debian/ buster-updates main
deb http://${MIRROR_HOST}/debian-security/ buster/updates main
deb-src http://${MIRROR_HOST}/debian-security/ buster/updates main
EOF

apt-get update
