# Base sourcelist
cat > $TARGET_DIR/etc/apt/sources.list <<EOF
deb http://${DEBIAN_MIRROR}/debian/ ${DEBIAN_CODENAME} main
deb-src http://${DEBIAN_MIRROR}/debian/ ${DEBIAN_CODENAME} main
deb http://${DEBIAN_MIRROR}/debian/ ${DEBIAN_CODENAME}-updates main
deb-src http://${DEBIAN_MIRROR}/debian/ ${DEBIAN_CODENAME}-updates main
EOF

# Install apt-transport-https
chroot $TARGET_DIR apt-get update
chroot $TARGET_DIR apt-get install -yq apt-transport-https ca-certificates

# HTTPS sourcelist
cat > $TARGET_DIR/etc/apt/sources.list <<EOF
deb https://${DEBIAN_MIRROR}/debian/ ${DEBIAN_CODENAME} main contrib non-free non-free-firmware
deb-src https://${DEBIAN_MIRROR}/debian/ ${DEBIAN_CODENAME} main contrib non-free non-free-firmware
deb https://${DEBIAN_MIRROR}/debian/ ${DEBIAN_CODENAME}-updates main contrib non-free non-free-firmware
deb-src https://${DEBIAN_MIRROR}/debian/ ${DEBIAN_CODENAME}-updates main contrib non-free non-free-firmware
deb https://${DEBIAN_MIRROR}/debian-security/ ${DEBIAN_CODENAME}-security main contrib non-free non-free-firmware
deb-src https://${DEBIAN_MIRROR}/debian-security/ ${DEBIAN_CODENAME}-security main contrib non-free non-free-firmware
EOF
