# Update source
chroot $TARGET_DIR apt-get update

# Update kernel version
# Get linux kernel version from current docker image
LINUX_VERSION=`ls /boot/vmlinuz-* | tail -n1 | awk -F- '{print $2 "-" $3}'`
chroot $TARGET_DIR apt-get install -yq linux-image-${LINUX_VERSION}-amd64
