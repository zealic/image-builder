#!/bin/bash
echo 'proc /proc proc defaults 0 0' >> $INST_DIR/etc/fstab
# Convert to vmdk
qemu-img convert -O vmdk disk.qcow2 disk.vmdk
