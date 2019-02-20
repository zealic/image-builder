#!/bin/bash
source /scripts/common-env.sh
source /scripts/common-load.sh
ln -sf $NBD_DEV  /dev/xvda
ln -sf $LOOP_DEV /dev/xvda1

#===============================================================================
# Generate grub.cfg
#===============================================================================
grub-install --boot-directory=/mnt/target/boot --modules="part_msdos" /dev/xvda

source /scripts/common-clean.sh
