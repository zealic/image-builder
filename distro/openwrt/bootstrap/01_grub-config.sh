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

mkdir -p $TARGET_DIR/boot/grub
grub-install --no-floppy --modules="part_msdos" \
   --root-directory=$TARGET_DIR --boot-directory=$TARGET_DIR/boot /dev/xvda

PARTUUID=`get_partuuid`
cat > $TARGET_DIR/boot/grub/grub.cfg <<EOF
serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1 --rtscts=off
terminal_input console serial; terminal_output console serial

set default="0"
set timeout="5"
set root='(hd0,msdos1)'

menuentry "OpenWrt" {
	#linux /boot/vmlinuz root=$PARTUUID rootfstype=ext4 rootwait console=tty0 console=ttyS0,115200n8 noinitrd
  linux /boot/vmlinuz root=/dev/sda1 rootfstype=ext4 rootwait console=tty0 console=ttyS0,115200n8 noinitrd
}
menuentry "OpenWrt (failsafe)" {
	linux /boot/vmlinuz failsafe=true root=$PARTUUID rootfstype=ext4 rootwait console=tty0 console=ttyS0,115200n8 noinitrd
}
EOF
