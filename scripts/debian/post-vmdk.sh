#!/bin/bash
INST_DIR=${INST_DIR:-/mnt/debinst}
NBD_DEV=/dev/nbd9
LOOP_DEV=/dev/loop4
IMAGE_FILE=${IMAGE_FILE:-/disk.qcow2}
SYSIMG_SIZE=${SYSIMG_SIZE:-$((4096*512))}

losetup -D
qemu-nbd -t -c $NBD_DEV $IMAGE_FILE
PART_OFFSET=$SYSIMG_SIZE
PART_SEC_COUNT=$(fdisk -l $NBD_DEV | grep ${NBD_DEV}p1 | awk '{ print $5}')
losetup -o $PART_OFFSET --sizelimit $((PART_SEC_COUNT*512)) $LOOP_DEV $NBD_DEV
ln -sf $NBD_DEV  /dev/xvda
ln -sf $LOOP_DEV /dev/xvda1

mkdir -p /mnt/target
mount $LOOP_DEV /mnt/target
cp -r $INST_DIR/* /mnt/target
grub-install --boot-directory=/mnt/target/boot --modules="part_msdos" /dev/xvda

#===============================================================================
# Generate MBR
#===============================================================================
# Install image
MODULES="part_msdos part_gpt fat ext2 gzio linux acpi normal \
    cpio crypto disk boot crc64 \
    search_fs_uuid verify xzio xfs video"
grub-mkimage -O i386-pc -p /boot -o core.img ${MODULES}
# grub-bios-setup
cp /usr/lib/grub/i386-pc/boot.img /
dd if=$NBD_DEV of=boot.img skip=446 bs=64 count=1 # copy partitations table

#===============================================================================
# Generate Image
#===============================================================================
dd if=boot.img of=$NBD_DEV bs=512 count=1
dd if=core.img of=$NBD_DEV seek=512

# Convert to vmdk
qemu-img convert -O vmdk disk.qcow2 disk.vmdk
