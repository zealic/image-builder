#!/bin/bash
INST_DIR=${INST_DIR:-/mnt/debinst}

#===============================================================================
# Generate grub.cfg
#===============================================================================
# manual grub-install
cp -r /usr/lib/grub/i386-pc $INST_DIR/boot/grub/i386-pc
grub-probe -d /dev/loop8 -t fs_uuid

# install image
MODULES="part_msdos part_gpt fat ext2 gzio linux acpi normal \
    cpio crypto disk boot crc64 \
    search_fs_uuid verify xzio xfs video"
grub-mkimage -O i386-pc -p /boot -o core.img ${MODULES}
# grub-bios-setup
cp /usr/lib/grub/i386-pc/boot.img /
dd if=$NBD_DEV of=boot.img skip=446 bs=64 count=1 # copy partitations table


#===============================================================================
# Generate grub.cfg
#===============================================================================
# Hook grub-probe
mv /usr/sbin/grub-probe /tmp/grub-probe
ln -sf /usr/local/sbin/grub-probe /usr/sbin/grub-probe

# Disable UEFT: /etc/grub.d/30_uefi-firmware
echo "" > /etc/grub.d/30_uefi-firmware

cat > /etc/default/grub <<"EOF"
GRUB_DEFAULT=0
GRUB_TIMEOUT=0
RUB_TIMEOUT_STYLE=menu
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_TERMINAL_INPUT=console
GRUB_TERMINAL_OUTPUT=console
GRUB_CMDLINE_LINUX="console=ttyS0,38400n8 elevator=noop scsi_mod.use_blk_mq=Y net.ifnames=0 biosdevname=0"
EOF

# Fake blkid
FS_UUID=`grub-probe --device $(grub-probe --target=device /) --target=fs_uuid`
mkdir -p /dev/disk/by-uuid/$FS_UUID

# Generate configuration
grub-mkconfig -o grub.cfg
