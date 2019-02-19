#!/bin/bash
INST_DIR=${INST_DIR:-/mnt/debinst}
IMAGE_FILE=${IMAGE_SIZE:-disk.qcow2}
IMAGE_SIZE=${IMAGE_SIZE:-$((1024*1024*1024*10))} # 10G
SYSIMG_SIZE=${SYSIMG_SIZE:-$((4096*512))}

# Make file system
qemu-img create -f qcow2 ${IMAGE_FILE} ${IMAGE_SIZE}
SID=${SID:-7}
LOOP_DEV=/dev/loop$(($SID+1))
NBD_DEV=/dev/nbd$SID
losetup -D
if [[ ! -e /dev/loop$SID ]]; then
  mknod /dev/loop$SID b 7 $SID
fi
if [[ ! -e $LOOP_DEV ]]; then
  mknod $LOOP_DEV b 7 $SID
fi
if [[ ! -e $NBD_DEV ]]; then
  mknod $NBD_DEV -m660 b 43 $SID
fi
qemu-nbd -t -c $NBD_DEV ${IMAGE_FILE}

# Make parts
parted $NBD_DEV "mklabel msdos"
parted $NBD_DEV "mkpart primary ext4 4096s -1"
parted $NBD_DEV set 1 boot on
PART_OFFSET=$SYSIMG_SIZE
PART_UUID=$(uuidgen | tr '[a-z]' '[A-Z]')
PART_SEC_COUNT=$(fdisk -l $NBD_DEV | grep ${NBD_DEV}p1 | awk '{ print $5}')
losetup -o $PART_OFFSET --sizelimit $((PART_SEC_COUNT*512)) $LOOP_DEV $NBD_DEV
yes | mkfs.ext4 -U $PART_UUID $LOOP_DEV
