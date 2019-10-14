mkdir /var/lock

sed -i 's/downloads\.openwrt\.org/openwrt\.proxy\.ustclug\.org/g' /etc/opkg/distfeeds.conf

opkg update
opkg install wget ca-certificates
sed -i 's/http:/https:/g' /etc/opkg/distfeeds.conf

cat > /etc/opkg/customfeeds.conf <<EOF
src/gz openwrt_dist http://openwrt-dist.sourceforge.net/packages/base/x86_64
src/gz openwrt_dist_luci http://openwrt-dist.sourceforge.net/packages/luci
EOF
