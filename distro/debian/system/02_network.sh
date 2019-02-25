apt-get update
apt-get install -yq \
  iptables iproute2 \
  net-tools iputils-ping dnsutils \
  telnet tcpdump

cat >> /etc/systemd/network/10-custom-network.network <<EOF
[Match]
Name=eth*

[Network]
DHCP=ipv4
LinkLocalAddressing=no
IPv6AcceptRA=np

[DHCP]
UseDomains=true

#[Address]
#Address=10.0.65.10/16
EOF

systemctl enable systemd-networkd
systemctl enable systemd-resolved

# Copy and link systemd resolve file
mkdir -p /run/systemd/resolve
chown systemd-resolve:systemd-resolve /run/systemd/resolve
cat /etc/resolv.conf > /run/systemd/resolve/resolve.conf
ln -sf /run/systemd/resolve/resolve.conf /etc/resolv.conf

# Reset hostname
rm /etc/hostname
