#!/bin/bash
#===============================================================================
# debootstrap install
#===============================================================================
CENTOS_VER=8.2.2004
CENTOS_REL_FILE=centos-release-8.2-2.2004.0.2.el8.x86_64.rpm

set -e
# Install yum, use vault to resolve 404 error
rpm --root $TARGET_DIR --nodeps -i https://vault.centos.org/${CENTOS_VER}/BaseOS/x86_64/os/Packages/${CENTOS_REL_FILE}
mkdir -p $TARGET_DIR/etc/pki/rpm-gpg && cp /etc/pki/rpm-gpg/* $TARGET_DIR/etc/pki/rpm-gpg
yum -y --installroot=$TARGET_DIR --releasever=8 install yum passwd
yum -y --installroot=$TARGET_DIR --releasever=8 install kernel grub2
