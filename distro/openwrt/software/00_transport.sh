mkdir /var/lock

# Use mirror
#sed -i 's/downloads\.openwrt\.org/openwrt\.proxy\.ustclug\.org/g' /etc/opkg/distfeeds.conf

# Use HTTPS source
opkg update
opkg install wget ca-certificates
sed -i 's/http:/https:/g' /etc/opkg/distfeeds.conf
opkg update
