#!/bin/bash
qemu-nbd -t -c $NBD_DEV ${IMAGE_FILE}
PART_SEC_COUNT=$(fdisk -l $NBD_DEV | grep ${NBD_DEV}p1 | awk '{ print $5}')
losetup -o $SYSIMG_SIZE --sizelimit $((PART_SEC_COUNT*512)) $LOOP_DEV $NBD_DEV
mkdir -p $TARGET_DIR
mount $LOOP_DEV $TARGET_DIR
