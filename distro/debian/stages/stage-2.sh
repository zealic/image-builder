#!/bin/bash
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
mkdir -p /dev/disk/by-uuid/$MAIN_UUID

# Generate
cat > /etc/default/grub <<"EOF"
GRUB_DEFAULT=0
GRUB_TIMEOUT=0
RUB_TIMEOUT_STYLE=menu
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_TERMINAL_INPUT=console
GRUB_TERMINAL_OUTPUT=console
GRUB_CMDLINE_LINUX="biosdevname=0 net.ifnames=0 console=ttyS0,38400n8d console=tty0 consoleblank=0 elevator=noop scsi_mod.use_blk_mq=Y"
EOF
grub-mkconfig -o $TARGET_DIR/boot/grub/grub.cfg
grub-install --boot-directory=/mnt/target/boot --modules="part_msdos" /dev/xvda
