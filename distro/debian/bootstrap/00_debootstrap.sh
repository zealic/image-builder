#!/bin/bash
#===============================================================================
# debootstrap install
#===============================================================================
set -e
debootstrap --arch=amd64 --foreign \
    --variant=minbase \
    --components=main,contrib,nonfree \
    --include=grub-pc \
    ${DEBIAN_CODENAME} ${TARGET_DIR} http://${DEBIAN_MIRROR}/debian
chroot $TARGET_DIR /debootstrap/debootstrap --second-stage

# Clean
chroot $TARGET_DIR apt clean
