#!/bin/bash
if [ -f $TARGET_FILE ]; then
  rm $TARGET_FILE
fi

cat > ${DISTRO_NAME}.vmx <<EOF
displayName = "${DISTRO_NAME}"
config.version = "8"
virtualHW.version = "11"
memsize = "1024"
mem.hotadd = "TRUE"
sata0.present = "TRUE"
sata0:0.present = "TRUE"
sata0:0.fileName = "${IMAGE_FILE}"
ethernet0.present = "TRUE"
ethernet0.connectionType = "nat"
ethernet0.virtualDev = "e1000"
ethernet0.wakeOnPcktRcv = "FALSE"
ethernet0.addressType = "generated"
guestOS = "otherlinux-64"
EOF

echo Generating ova...
# Best performance building in container dir
ovftool ${DISTRO_NAME}.vmx /${DISTRO_NAME}.ova
mv /${DISTRO_NAME}.ova /$TARGET_FILE
