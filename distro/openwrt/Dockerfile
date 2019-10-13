FROM debian:9-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN export MAIN_DEPS="curl grub-pc qemu-utils parted uuid-runtime kmod" \
  && apt-get update && apt-get install -yq ${MAIN_DEPS} \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV OVFTOOL_VER=4.3.0-7948156
ENV OVFTOOL_URL=https://raw.githubusercontent.com/smarunich/avitoolbox/master/files/VMware-ovftool-${OVFTOOL_VER}-lin.x86_64.bundle
RUN curl -sSL ${OVFTOOL_URL} > /tmp/ovftool.bundle \
  && chmod +x /tmp/ovftool.bundle \
  && echo -n "\n" | /tmp/ovftool.bundle --eulas-agreed \
  && rm -rf /tmp/*
