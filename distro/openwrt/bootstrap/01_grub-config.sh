#!/bin/bash
ln -sf $NBD_DEV  /dev/xvda
ln -sf $LOOP_DEV /dev/xvda1

#===============================================================================
# Generate grub.cfg
#===============================================================================
# Hook grub-probe to generate args
mv /usr/sbin/grub-probe /tmp/grub-probe
cat > /usr/sbin/grub-probe <<"EOF"
#!/bin/bash
XVDAP1=/dev/xvda1
if [[ "$1" == '--device' ]] && [[ "$2" == "$XVDAP1" ]]; then
  case x"$3" in
    x--target=partmap)
      echo "msdos"
      exit 0;;
  esac
  :
fi

if [[ "$1" == '--target=device' ]]; then
  case x"$2" in
    x/)
      echo "$XVDAP1"
      exit 0;;
    x/boot)
      echo "$XVDAP1"
      exit 0;;
  esac
fi

exec /tmp/grub-probe $@
EOF
chmod +x /usr/sbin/grub-probe

# Disable UEFT: /etc/grub.d/30_uefi-firmware
echo "" > /etc/grub.d/30_uefi-firmware

# Fake blkid, grub-mkconfig setroot need this
mkdir -p /dev/disk/by-uuid/$MAIN_UUID

# Generate
cat > /etc/default/grub <<"EOF"
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_TIMEOUT_STYLE=menu
GRUB_DISTRIBUTOR=OpenWrt
GRUB_TERMINAL_INPUT=console
GRUB_TERMINAL_OUTPUT=console
GRUB_CMDLINE_LINUX="rootfstype=ext4 rootwait console=tty0 console=ttyS0,115200n8 noinitrd"
EOF

mkdir -p $TARGET_DIR/boot/grub
grub-mkconfig -o $TARGET_DIR/boot/grub/grub.cfg
grub-install --no-floppy --root-directory=$TARGET_DIR --boot-directory=$TARGET_DIR/boot /dev/xvda
