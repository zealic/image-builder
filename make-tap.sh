#!/bin/bash
NETDIR=/etc/systemd/network
cat > $NETDIR/tap-qemu.netdev <<EOF
[NetDev]
Name=tap-qemu
Kind=tap
EOF

cat > $NETDIR/tap-qemu.network <<EOF
[Match]
Name=tap-qemu

[Network]
Bridge=br-lan
EOF
