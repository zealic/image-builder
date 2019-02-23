cat > /etc/sysctl.d/40-ip.conf <<EOF
# Enable IPv4 IP forward
net.ipv4.ip_forward = 1
# Disable IPv6
net.ipv6.conf.all.disable_ipv6 = 1
EOF
