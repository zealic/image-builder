ARG DISTRO_VER=12
FROM debian:${DISTRO_VER}-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN export MAIN_DEPS="curl grub-pc qemu-utils parted fdisk uuid-runtime kmod" \
  && export IMG_DEPS="debootstrap linux-image-amd64" \
  && apt-get update && apt-get install -yq ${MAIN_DEPS} ${IMG_DEPS} \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# TODO: use another url.
ENV OVFTOOL_VER=4.4.0-16360108
ENV OVFTOOL_URL=https://stsharedservices.blob.core.windows.net/pub/ovftool/VMware-ovftool-${OVFTOOL_VER}-lin.x86_64.bundle
RUN curl -sSL ${OVFTOOL_URL} > /tmp/ovftool.bundle \
  && chmod +x /tmp/ovftool.bundle \
  && echo -n "\n" | /tmp/ovftool.bundle --eulas-agreed \
  && rm -rf /tmp/*
