apt-get install -yq \
  iptables iproute2 \
  net-tools iputils-ping dnsutils traceroute \
  telnet tcpdump

NETDIR=/etc/systemd/network

cat > $NETDIR/10-static.network <<EOF
[Match]
Name=eth0

[Network]
IPForward=ipv4
LinkLocalAddressing=no
IPv6AcceptRA=no
Address=192.168.1.32/16
Gateway=192.168.1.1
DNS=192.168.1.1
EOF

EXAMPLE1=$NETDIR/br-lan.example
mkdir -p $EXAMPLE1
cat > $EXAMPLE1/br-lan.netdev <<EOF
[NetDev]
Name=br-lan
Kind=bridge
EOF

cat > $EXAMPLE1/br-lan-dhcp.network <<EOF
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
Address=192.167.1.128/16
EOF

cat > $EXAMPLE1/br-lan-static.network <<EOF
# If want use static address only, remove DHCP file
[Match]
Name=br-lan

[Network]
IPForward=ipv4
LinkLocalAddressing=no
IPv6AcceptRA=no
Address=192.168.1.64/16
Gateway=192.168.1.1
DNS=192.168.1.1
EOF

cat > $EXAMPLE1/br-lan-eth.network <<EOF
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
