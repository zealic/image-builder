#!/bin/bash
source /scripts/common/common-env.sh

echo "################################################################################"
echo "$PIPELINE_NAME"
echo "################################################################################"

########################################
# Create snapshot
########################################
if [[ -z "$ROOT_PIPELINE" ]]; then
  # Snapshot
  qemu-img create -f qcow2 -b ${BASE_IMAGE} ${IMAGE_FILE}
  exit
fi

#===============================================================================
# Make root image
#===============================================================================
if lsmod | grep nbd ; then
    echo NBD OK 
else
    echo Need enable NBD module!
    exit 1
fi

# Make file system
qemu-img create -f qcow2 ${IMAGE_FILE} ${IMAGE_SIZE}
qemu-nbd -t -c $NBD_DEV ${IMAGE_FILE}

# Make parts
parted $NBD_DEV "mklabel msdos"
parted $NBD_DEV "mkpart primary ext4 ${SYSIMG_SECT_COUNT}s -1"
parted $NBD_DEV set 1 boot on
PART_SEC_COUNT=$(fdisk -l $NBD_DEV | grep ${NBD_DEV}p1 | awk '{ print $5}')
losetup -o $SYSIMG_SIZE --sizelimit $(($PART_SEC_COUNT*$SECT_SIZE)) $LOOP_DEV $NBD_DEV
yes | mkfs.ext4 -U $MAIN_UUID $LOOP_DEV
