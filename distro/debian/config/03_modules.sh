apt-get install -yq \
  fuse

cat > /etc/modules-load.d/fuse.conf <<EOF
fuse
EOF

# nbd
cat > /etc/modules-load.d/nbd.conf <<EOF
nbd
EOF
