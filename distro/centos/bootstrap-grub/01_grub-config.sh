#!/bin/bash
ln -sf $NBD_DEV  /dev/xvda
ln -sf $LOOP_DEV /dev/xvda1

#===============================================================================
# Generate grub.cfg
#===============================================================================
# Hook grub-probe2 to generate args
mv /usr/sbin/grub2-probe /tmp/grub2-probe
cat > /usr/sbin/grub2-probe <<"EOF"
#!/bin/bash
XVDAP1=/dev/xvda1
if [[ "$1" == '--device' ]] && [[ "$2" == "$XVDAP1" ]]; then
  case x"$3" in
    x--target=partmap)
      echo "msdos"
      exit 0;;
    x--target=partuuid)
      echo `get_partuuid`
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

exec /tmp/grub2-probe $@
EOF
chmod +x /usr/sbin/grub2-probe

# Disable UEFT: /etc/grub.d/30_uefi-firmware
echo "" > /etc/grub.d/30_uefi-firmware

# Fake blkid, grub-mkconfig setroot need this
mkdir -p /dev/disk/by-uuid/$MAIN_UUID

# Fake kernel for grub2-mkconfig
cp $TARGET_DIR/boot/*.* /boot

# Generate
cat > /etc/default/grub <<"EOF"
GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_TIMEOUT_STYLE=menu
GRUB_DISTRIBUTOR=`sed 's, release .*$,,g' /etc/system-release || echo CentOS`
GRUB_TERMINAL_INPUT=console
GRUB_TERMINAL_OUTPUT=console
GRUB_CMDLINE_LINUX="biosdevname=0 net.ifnames=0 console=ttyS0,38400n8d console=tty0 consoleblank=0 elevator=noop scsi_mod.use_blk_mq=Y"
EOF
grub2-mkconfig -o $TARGET_DIR/boot/grub2/grub.cfg
grub2-install --boot-directory=$TARGET_DIR/boot --modules="part_msdos" /dev/xvda
