# See also: https://github.com/simonsmh/openwrt-dist
wget -O /tmp/dist.pub https://cdn.jsdelivr.net/gh/simonsmh/openwrt-dist@master/simonsmh-dist.pub
opkg-key add /tmp/dist.pub
cat > /etc/opkg/customfeeds.conf <<EOF
src/gz simonsmh https://cdn.jsdelivr.net/gh/simonsmh/openwrt-dist@packages/x86/64
EOF
