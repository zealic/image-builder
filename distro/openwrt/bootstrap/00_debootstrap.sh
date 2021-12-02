#!/bin/bash
#===============================================================================
# debootstrap install
#===============================================================================
OPENWRT_VER=${DISTRO_VER}
OPENWRT_URL=https://${OPENWRT_MIRROR}/releases/${OPENWRT_VER}/targets/x86/64/openwrt-${OPENWRT_VER}-x86-64-rootfs.tar.gz
VMLINUZ_URL=https://${OPENWRT_MIRROR}/releases/${OPENWRT_VER}/targets/x86/64/openwrt-${OPENWRT_VER}-x86-64-generic-kernel.bin
mkdir -p $TARGET_DIR/boot
curl -sSL $OPENWRT_URL | tar -C $TARGET_DIR -xvzf - > /dev/null
curl -sSL -o $TARGET_DIR/boot/vmlinuz $VMLINUZ_URL
