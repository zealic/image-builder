#!/bin/bash
#===============================================================================
# Configure
#===============================================================================
# Configure /etc/fstab
echo 'proc /proc proc defaults 0 0' >  $TARGET_DIR/etc/fstab
echo "UUID=$MAIN_UUID / ext4 defaults 1 1" >> $TARGET_DIR/etc/fstab

# Configure passwd
chroot $TARGET_DIR passwd -d root
