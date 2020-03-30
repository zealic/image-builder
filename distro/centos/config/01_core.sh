# Reinstall package managers and install base packages
yum install -y hostname
yum --releasever=8 install -y yum centos-release

# is dracut-squash, dracut-network, and dracut-config-generic necessary?
yum install -y redhat-lsb-core dracut-tools dracut-squash dracut-network dracut-config-rescue dracut-config-generic
yum install -y coreutils --allowerasing
