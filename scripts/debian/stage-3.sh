#!/bin/bash
source /scripts/common-env.sh
source /scripts/common-snapshot.sh
source /scripts/common-load.sh

#===============================================================================
# Configure
#===============================================================================
# Configure /etc/fstab
echo 'proc /proc proc defaults 0 0' >  $TARGET_DIR/etc/fstab
echo "UUID=$MAIN_UUID / ext4 defaults 1 1" >> $TARGET_DIR/etc/fstab

# Configure passwd
passwd -d root

source /scripts/common-clean.sh
