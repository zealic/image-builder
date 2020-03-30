#!/bin/bash
#===============================================================================
# debootstrap install
#===============================================================================
set -e
# Install yum
rpm --root $TARGET_DIR --nodeps -i http://mirror.centos.org/centos/8.1.1911/BaseOS/x86_64/os/Packages/centos-release-8.1-1.1911.0.8.el8.x86_64.rpm
mkdir -p $TARGET_DIR/etc/pki/rpm-gpg && cp /etc/pki/rpm-gpg/* $TARGET_DIR/etc/pki/rpm-gpg
yum -y --installroot=$TARGET_DIR --releasever=8 install yum passwd
yum -y --installroot=$TARGET_DIR --releasever=8 install kernel grub2
