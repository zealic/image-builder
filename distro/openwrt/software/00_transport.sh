mkdir /var/lock

# Use mirror
 sed -i "s|downloads.openwrt.org|${OPENWRT_MIRROR}|g" /etc/opkg/distfeeds.conf
#sed -i 's/downloads\.openwrt\.org/openwrt\.proxy\.ustclug\.org/g' /etc/opkg/distfeeds.conf

# Use HTTPS source
sed -i 's/https:/http:/g' /etc/opkg/distfeeds.conf
opkg update
opkg remove luci-ssl libustream-wolfssl*
opkg install ca-bundle ca-certificates libustream-openssl luci-ssl
opkg install wget-ssl
sed -i 's/http:/https:/g' /etc/opkg/distfeeds.conf
opkg update
