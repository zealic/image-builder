#!/bin/bash
echo 'proc /proc proc defaults 0 0' > etc/fstab

# Boot Image
MODULES="part_gpt fat ext2 gzio linux acpi normal \
    cpio crypto disk boot crc64 gpt \
    search_disk_uuid tftp verify xzio xfs video"
grub-mkimage -O i386-pc -p /boot -o core.img ${MODULES}

$CHROOT_RUN apt install linux-image-amd64

# cat /usr/lib/grub/i386-pc-bin/mod/boot.img core.img > system.img
