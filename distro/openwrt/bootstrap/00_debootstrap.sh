#!/bin/bash
#===============================================================================
# debootstrap install
#===============================================================================
OPENWRT_VER=18.06.2
OPENWRT_URL=https://downloads.openwrt.org/releases/${OPENWRT_VER}/targets/x86/64/openwrt-${OPENWRT_VER}-x86-64-generic-rootfs.tar.gz

wget -qO- $OPENWRT_URL | tar -C $TARGET_DIR -xvzf -
