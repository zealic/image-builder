#!/bin/bash
DISTRO_NAME=${DISTRO_NAME}
# generate ova
OUTPUT=${DISTRO_NAME:-default}.ova
if [ -f $OUTPUT ]; then
  rm $OUTPUT
fi

cat > ${DISTRO_NAME}.vmx <<EOF
displayName = "${DISTRO_NAME}"
config.version = "8"
virtualHW.version = "11"
memsize = "1024"
mem.hotadd = "TRUE"
sata0.present = "TRUE"
sata0:0.present = "TRUE"
sata0:0.fileName = "${DISTRO_NAME}.vmdk"
ethernet0.present = "TRUE"
ethernet0.connectionType = "nat"
ethernet0.virtualDev = "e1000"
ethernet0.wakeOnPcktRcv = "FALSE"
ethernet0.addressType = "generated"
guestOS = "otherlinux-64"
EOF

echo Generating vmdk...
qemu-img convert -O vmdk ${IMAGE_FILE} ${DISTRO_NAME}.vmdk
echo Generating ova...

# Best performance building in container dir
ovftool ${DISTRO_NAME}.vmx /${OUTPUT}
mv /$OUTPUT $PWD
