apt-get update
apt-get install -yq \
  sudo coreutils binutils systemd \
  ethtool ifupdown iptables iproute2 net-tools iputils-ping \
  curl \
  git openssh-server

cat >> /etc/network/interfaces <<EOF
auto eth0
iface eth0 inet dhcp
EOF

systemctl enable ssh
