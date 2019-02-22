cat > /etc/sysctl.d/40-ip.conf <<EOF
# IPv4
net.ipv4.ip_forward = 1
# IPv6
net.ipv6.conf.all.disable_ipv6 = 1
EOF