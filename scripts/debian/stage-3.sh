#!/bin/bash
source /scripts/common-env.sh
source /scripts/common-load.sh
ln -sf $NBD_DEV  /dev/xvda
ln -sf $LOOP_DEV /dev/xvda1

#===============================================================================
# Generate grub.cfg
#===============================================================================
# Hook grub-probe to generate args
mv /usr/sbin/grub-probe /tmp/grub-probe
cp /scripts/grub-probe-hook /usr/sbin/grub-probe
chmod +x /usr/sbin/grub-probe

# Disable UEFT: /etc/grub.d/30_uefi-firmware
echo "" > /etc/grub.d/30_uefi-firmware

# Fake blkid, grub-mkconfig setroot need this
FS_UUID=`blkid -o "export" $LOOP_DEV | grep UUID | cut -c6-`
mkdir -p /dev/disk/by-uuid/$FS_UUID

# Setup mount table
echo 'proc /proc proc defaults 0 0' >  $TARGET_DIR/etc/fstab
echo "UUID=$FS_UUID / ext4 defaults 1 1" >> $TARGET_DIR/etc/fstab

# Generate
cat > /etc/default/grub <<"EOF"
GRUB_DEFAULT=0
GRUB_TIMEOUT=30
RUB_TIMEOUT_STYLE=menu
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_TERMINAL_INPUT=console
GRUB_TERMINAL_OUTPUT=console
GRUB_CMDLINE_LINUX="console=ttyS0,38400n8d console=tty0 consoleblank=0 biosdevname=0 net.ifnames=0 elevator=noop scsi_mod.use_blk_mq=Y"
EOF
grub-mkconfig -o $TARGET_DIR/boot/grub/grub.cfg
grub-install --boot-directory=/mnt/target/boot --modules="part_msdos" /dev/xvda


source /scripts/common-clean.sh
