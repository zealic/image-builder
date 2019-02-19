#!/bin/bash
CHROOT_RUN="chroot $INST_DIR"
export LANG=C.UTF-8

# Setup second-stage
$CHROOT_RUN /debootstrap/debootstrap --second-stage
