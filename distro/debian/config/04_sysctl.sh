cat > /etc/security/limits.d/10-files.conf <<EOF
root soft nofile 65535
root hard nofile 65535
* soft nofile 65535
* hard nofile 65535
EOF

cat > /etc/sysctl.d/40-ip.conf <<EOF
# Enable IPv4 IP forward
net.ipv4.ip_forward = 1
# Disable IPv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

cat > /etc/sysctl.d/41-network.conf <<EOF
# for Docker and Romana
net.bridge.bridge-nf-call-iptables=1
EOF
