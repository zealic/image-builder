apt-get update
apt-get install -yq \
  iptables iproute2 \
  net-tools iputils-ping dnsutils \
  telnet tcpdump

cat >> /etc/systemd/network/10-dhcp.network <<EOF
[Match]
Name=eth*

[Network]
DHCP=ipv4
LinkLocalAddressing=no
IPv6AcceptRA=no

[DHCP]
UseDomains=true
EOF

cat >> /etc/systemd/network/20-static-address.network <<EOF
[Match]
Name=eth*

[Network]
Gateway=10.0.0.1
DNS=10.0.0.1
IPForward=ipv4

[Address]
Address=10.0.22.33/16
EOF

systemctl enable systemd-networkd
systemctl enable systemd-resolved

# Copy and link systemd resolve file
mkdir -p /run/systemd/resolve
chown systemd-resolve:systemd-resolve /run/systemd/resolve
cat /etc/resolv.conf > /run/systemd/resolve/resolve.conf
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Reset hostname
rm /etc/hostname
