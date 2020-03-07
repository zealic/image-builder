#!/bin/bash
export LANG=C.UTF-8
MIRROR_HOST=${MIRROR_HOST:-http://deb.debian.org/debian/}
# Directory
WORKSPACE=/workspace
TARGET_DIR=/mnt/target

# Disk info
IMAGE_FILE=${IMAGE_FILE:-disk.qcow2}
IMAGE_SIZE=${IMAGE_SIZE:-$((1024*1024*1024*20))} # 20G
SECT_SIZE=512
SYSIMG_SECT_COUNT=4096
SYSIMG_SIZE=${SYSIMG_SIZE:-$(($SYSIMG_SECT_COUNT*$SECT_SIZE))}

# Part UUID
get_uuid() {
  if [[ ! -f $WORKSPACE/.uuid ]]; then
    uuidgen > $WORKSPACE/.uuid
  fi
  cat $WORKSPACE/.uuid
}
MAIN_UUID=`get_uuid`
if [[ "$MAIN_UUID" == "" ]]; then
  echo "Invalid UUID '$MAIN_UUID'."
  exit 1
fi

# Device
# drivers/block/nbd.c defined 'static unsigned int nbds_max = 16'
DEVID=${DEVID:-$(($RANDOM % 16))}
LOOP_DEV=/dev/loop$DEVID
NBD_DEV=/dev/nbd$DEVID

get_partuuid() {
  local ptuuid=`blkid | grep $NBD_DEV | awk '{print $2}' | sed 's/"//g'`
  echo "${ptuuid#*=}"
}

# Load devices
if [[ ! -e $LOOP_DEV ]]; then
  mknod $LOOP_DEV b 7 $DEVID
fi
if [[ ! -e $NBD_DEV ]]; then
  mknod $NBD_DEV -m660 b 43 $DEVID
fi

if [[ -e $LOOP_DEV ]]; then
  losetup -d $LOOP_DEV 2> /dev/null
fi
