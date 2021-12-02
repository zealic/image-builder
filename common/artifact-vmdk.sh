#!/bin/bash
echo Generating vmdk...
qemu-img convert -c -O vmdk ${IMAGE_FILE} ${TARGET_FILE}
chmod 644 ${TARGET_FILE}
