#!/bin/bash
DIST_NAME=${DIST_NAME:-$1}
# generate ova
OUTPUT=${DIST_NAME:-default}.ova
if [ -f $OUTPUT ]; then
  rm $OUTPUT
fi

cat > ${DIST_NAME}.vmx <<EOF
displayName = "${DIST_NAME}"
config.version = "8"
virtualHW.version = "11"
memsize = "1024"
mem.hotadd = "TRUE"
sata0.present = "TRUE"
sata0:0.present = "TRUE"
sata0:0.fileName = "${DIST_NAME}.vmdk"
ethernet0.present = "TRUE"
ethernet0.connectionType = "nat"
ethernet0.virtualDev = "e1000"
ethernet0.wakeOnPcktRcv = "FALSE"
ethernet0.addressType = "generated"
guestOS = "otherlinux-64"
EOF

echo Generating vmdk...
qemu-img convert -O vmdk ${IMAGE_FILE} ${DIST_NAME}.vmdk
echo Generating ova...

# Best performance building in container dir
ovftool ${DIST_NAME}.vmx /${OUTPUT}
mv /$OUTPUT $PWD
