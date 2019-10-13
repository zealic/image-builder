#!/bin/bash
#===============================================================================
# debootstrap install
#===============================================================================
OPENWRT_VER=19.07
OPENWRT_URL=https://downloads.openwrt.org/releases/${OPENWRT_VER}/targets/x86/64/openwrt-${OPENWRT_VER}-x86-64-generic-rootfs.tar.gz
VMLINUZ_URL=https://downloads.openwrt.org/releases/${OPENWRT_VER}/targets/x86/64/openwrt-${OPENWRT_VER}-x86-64-vmlinuz
OPENWRT_URL=https://downloads.openwrt.org/snapshots/targets/x86/64/openwrt-x86-64-generic-rootfs.tar.gz
VMLINUZ_URL=https://downloads.openwrt.org/snapshots/targets/x86/64/openwrt-x86-64-vmlinuz

mkdir -p $TARGET_DIR/boot
curl -sSL $OPENWRT_URL | tar -C $TARGET_DIR -xvzf -
curl -sSL -o $TARGET_DIR/boot/vmlinuz $VMLINUZ_URL
