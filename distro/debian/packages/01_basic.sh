apt-get update
apt-get install -yq \
  sudo coreutils binutils e2fsprogs systemd systemd-sysv \
  ethtool ifupdown iptables iproute2 net-tools iputils-ping \
  curl vim \
  git openssh-server

cat >> /etc/network/interfaces <<EOF
auto eth0
iface eth0 inet dhcp
EOF

systemctl enable ssh
