FROM debian:12-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN export MAIN_DEPS="curl grub-pc qemu-utils parted fdisk uuid-runtime kmod" \
  && apt-get update && apt-get install -yq ${MAIN_DEPS} \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV OVFTOOL_VER=4.4.0-16360108
ENV OVFTOOL_URL=https://github.com/vmware/nsx-advanced-load-balancer-tools/raw/master/files/VMware-ovftool-4.4.0-16360108-lin.x86_64.bundle
RUN curl -sSL ${OVFTOOL_URL} > /tmp/ovftool.bundle \
  && chmod +x /tmp/ovftool.bundle \
  && echo -n "\n" | /tmp/ovftool.bundle --eulas-agreed \
  && rm -rf /tmp/*
