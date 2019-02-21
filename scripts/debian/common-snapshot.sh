#!/bin/bash
pushd $WORKSPACE
  qemu-img create -f qcow2 -b ${BASE_IMAGE} ${IMAGE_FILE}
popd
