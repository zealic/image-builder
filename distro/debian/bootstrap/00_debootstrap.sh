#!/bin/bash
#===============================================================================
# debootstrap install
#===============================================================================
set -e
# Get linux kernel version from current docker image
LINUX_VERSION=`ls /boot/vmlinuz-* | tail -n1 | awk -F- '{print $2 "-" $3}'`
debootstrap --arch=amd64 --foreign \
    --variant=minbase \
    --components=main,contrib,nonfree \
    --include=linux-image-${LINUX_VERSION}-amd64,grub-pc \
    ${DEBIAN_CODENAME} ${TARGET_DIR} http://${DEBIAN_MIRROR}/debian
chroot $TARGET_DIR /debootstrap/debootstrap --second-stage
chroot $TARGET_DIR apt clean
