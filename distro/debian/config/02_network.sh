apt-get install -yq \
  iptables iproute2 \
  net-tools iputils-ping dnsutils traceroute \
  telnet tcpdump

NETDIR=/etc/systemd/network
cat > $NETDIR/br-lan.netdev <<EOF
[NetDev]
Name=br-lan
Kind=bridge
EOF

cat > $NETDIR/br-lan-dhcp.network <<EOF
# If want use static address only, remove this file
[Match]
Name=br-lan

[Network]
IPForward=ipv4
LinkLocalAddressing=no
IPv6AcceptRA=no
DHCP=ipv4

[DHCP]
ClientIdentifier=mac
UseDomains=true

# With static address
[Address]
Address=10.0.11.64/16
EOF

cat > $NETDIR/br-lan-static.network <<EOF
# If want use static address only, remove DHCP file
[Match]
Name=br-lan

[Network]
IPForward=ipv4
LinkLocalAddressing=no
IPv6AcceptRA=no
Gateway=10.0.0.1
DNS=10.0.0.1

[Address]
Address=10.0.11.64/16
EOF

cat > $NETDIR/br-lan-eth.network <<EOF
[Match]
Name=eth*

[Network]
Bridge=br-lan
EOF

systemctl enable systemd-networkd
systemctl enable systemd-resolved

# Copy and link systemd resolve file
mkdir -p /run/systemd/resolve
chown systemd-resolve:systemd-resolve /run/systemd/resolve
cat /etc/resolv.conf > /run/systemd/resolve/resolv.conf
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Reset hostname
rm /etc/hostname
