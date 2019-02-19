#!/bin/bash
echo 'proc /proc proc defaults 0 0' >> $INST_DIR/etc/fstab

dd if=system.img of=$NBD_DEV
mount $LOOP_DEV /mnt/target

# Convert to vmdk
qemu-img convert -O vmdk disk.qcow2 disk.vmdk
