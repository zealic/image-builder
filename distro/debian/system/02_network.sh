apt-get update
apt-get install -yq \
  ethtool ifupdown iptables iproute2 net-tools iputils-ping

cat >> /etc/network/interfaces <<EOF
# The dhcp address
auto eth0
iface eth0 inet dhcp

# The static address
#iface eth0 inet static
#	address 10.0.0.200
#	netmask 255.255.0.0
#	gateway 10.0.0.1
#	dns-nameservers 10.0.0.1
EOF
