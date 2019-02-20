#!/bin/bash
source /scripts/common-env.sh
source /scripts/common-load.sh
ln -sf $NBD_DEV  /dev/xvda
ln -sf $LOOP_DEV /dev/xvda1

#===============================================================================
# Generate grub.cfg
#===============================================================================
# Hook grub-probe
mv /usr/sbin/grub-probe /tmp/grub-probe
cp /scripts/grub-probe-hook /usr/sbin/grub-probe
chmod +x /usr/sbin/grub-probe

# Disable UEFT: /etc/grub.d/30_uefi-firmware
echo "" > /etc/grub.d/30_uefi-firmware

cat > /etc/default/grub <<"EOF"
GRUB_DEFAULT=0
GRUB_TIMEOUT=30
RUB_TIMEOUT_STYLE=menu
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_TERMINAL_INPUT=console
GRUB_TERMINAL_OUTPUT=console
GRUB_CMDLINE_LINUX="console=ttyS0,38400n8 elevator=noop scsi_mod.use_blk_mq=Y net.ifnames=0 biosdevname=0"
EOF

# Fake blkid
FS_UUID=`blkid -o "export" $LOOP_DEV | grep UUID | cut -c6-`
mkdir -p $TARGET_DIR/dev/disk/by-uuid/$FS_UUID

echo 'proc /proc proc defaults 0 0' >  $TARGET_DIR/etc/fstab
echo "UUID=$FS_UUID / ext4 defaults 1 1" >> $TARGET_DIR/etc/fstab

# Generate configuration
grub-mkconfig -o /grub.cfg
cp /grub.cfg $TARGET_DIR/boot/grub

source /scripts/common-clean.sh
