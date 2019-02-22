#!/bin/bash
qemu-img create -f qcow2 -b ${BASE_IMAGE} ${IMAGE_FILE}
