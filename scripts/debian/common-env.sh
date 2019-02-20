#!/bin/bash
export LANG=C.UTF-8
INST_DIR=${INST_DIR:-/mnt/debinst}
IMAGE_FILE=${IMAGE_FILE:-disk.qcow2}
IMAGE_SIZE=${IMAGE_SIZE:-$((1024*1024*1024*10))} # 10G
SYSIMG_SIZE=${SYSIMG_SIZE:-$((4096*512))}
MAIN_UUID=${MAIN_UUID:-27428078-ba16-45d5-8338-47e105b4fc7c}
SID=${SID:-7}
LOOP_DEV=/dev/loop$(($SID+1))
NBD_DEV=/dev/nbd$SID
TARGET_DIR=/mnt/target

# Load devices
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
