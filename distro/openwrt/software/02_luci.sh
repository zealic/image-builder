# Fix missing in luci
# See also: https://forum.openwrt.org/t/etc-config-luci-missing-themes/67990/2
opkg remove --force-depends luci-theme-bootstrap
opkg install luci luci-theme-bootstrap
