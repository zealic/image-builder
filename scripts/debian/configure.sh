#!/bin/bash
export LANG=C.UTF-8
export CHROOT_RUN="chroot $INST_DIR"
export SYSIMG_SIZE=$((4096*512))

source /scripts/configure-disk.sh
source /scripts/configure-grub.sh
