#!/bin/bash
source /scripts/common-env.sh
#===============================================================================
# Make image
#===============================================================================
# Make file system
qemu-img create -f qcow2 ${IMAGE_FILE} ${IMAGE_SIZE}
qemu-nbd -t -c $NBD_DEV ${IMAGE_FILE}

# Make parts
parted $NBD_DEV "mklabel msdos"
parted $NBD_DEV "mkpart primary ext4 4096s -1"
parted $NBD_DEV set 1 boot on
PART_SEC_COUNT=$(fdisk -l $NBD_DEV | grep ${NBD_DEV}p1 | awk '{ print $5}')
losetup -o $SYSIMG_SIZE --sizelimit $((PART_SEC_COUNT*512)) $LOOP_DEV $NBD_DEV
yes | mkfs.ext4 -U $MAIN_UUID $LOOP_DEV

#===============================================================================
# Setup second-stage
#===============================================================================
mkdir -p $TARGET_DIR
mount $LOOP_DEV $TARGET_DIR
cp -r $INST_DIR/* $TARGET_DIR
chroot $TARGET_DIR /debootstrap/debootstrap --second-stage

source /scripts/common-clean.sh
