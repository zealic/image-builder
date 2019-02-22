#!/bin/bash
if [[ -d $TARGET_DIR ]]; then
  umount $TARGET_DIR
fi

losetup -D
qemu-nbd -d $NBD_DEV
