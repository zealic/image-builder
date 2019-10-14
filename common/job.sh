#!/bin/bash
source /scripts/common/common-env.sh

########################################
# Load Image
########################################
# Load and mount device
qemu-nbd -t -c $NBD_DEV ${IMAGE_FILE}
PART_SEC_COUNT=$(fdisk -l $NBD_DEV | grep ${NBD_DEV}p1 | awk '{ print $5}')
losetup -o $SYSIMG_SIZE --sizelimit $((PART_SEC_COUNT*512)) $LOOP_DEV $NBD_DEV
if [[ ! -d $TARGET_DIR ]]; then
  mkdir -p $TARGET_DIR
fi
mount $LOOP_DEV $TARGET_DIR


########################################
# Execute Job
########################################
echo "########################################"
echo "$PIPELINE_NAME - $PIPELINE_JOB"
echo "########################################"
JOB_FILE=/scripts/pipelines/$PIPELINE_NAME/$PIPELINE_JOB.sh
if [[ -e $JOB_FILE ]]; then
  if [[ -z $CHROOT ]]; then
    source $JOB_FILE
  else # chroot run
    cp $JOB_FILE $TARGET_DIR/tmp/$PIPELINE_JOB.sh
    chroot $TARGET_DIR $CHROOT_SHELL /tmp/$PIPELINE_JOB.sh
    rm $TARGET_DIR/tmp/$PIPELINE_JOB.sh
  fi
fi


########################################
# Cleanup
########################################
if [[ -d $TARGET_DIR ]]; then
  umount $TARGET_DIR
fi

losetup -D
qemu-nbd -d $NBD_DEV > /dev/null
