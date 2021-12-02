mkdir -p /etc/apt/sources.list.d
cat > /etc/apt/sources.list.d/backports.list <<"EOF"
deb http://deb.debian.org/debian/ ${DEBIAN_CODENAME}-backports main
deb-src http://deb.debian.org/debian/ ${DEBIAN_CODENAME}-backports main
EOF

cat > /etc/apt/sources.list.d/google-cloud.list <<"EOF"
deb http://packages.cloud.google.com/apt cloud-sdk-${DEBIAN_CODENAME} main
deb http://packages.cloud.google.com/apt google-compute-engine-${DEBIAN_CODENAME}-stable main
deb http://packages.cloud.google.com/apt google-cloud-packages-archive-keyring-${DEBIAN_CODENAME} main
EOF
