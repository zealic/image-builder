# See also: http://openwrt-dist.sourceforge.net/
wget -O /tmp/openwrt-dist.pub http://openwrt-dist.sourceforge.net/openwrt-dist.pub
opkg-key add /tmp/openwrt-dist.pub

# See also: https://github.com/simonsmh/openwrt-dist
wget -O /tmp/simonsmh-dist.pub https://cdn.jsdelivr.net/gh/simonsmh/openwrt-dist@master/simonsmh-dist.pub
opkg-key add /tmp/simonsmh-dist.pub

cat > /etc/opkg/customfeeds.conf <<EOF
src/gz openwrt_dist http://openwrt-dist.sourceforge.net/packages/base/x86_64/
src/gz openwrt_dist_luci http://openwrt-dist.sourceforge.net/packages/luci
src/gz simonsmh https://cdn.jsdelivr.net/gh/simonsmh/openwrt-dist@packages/x86/64
EOF
