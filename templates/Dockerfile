FROM debian:9-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN export DEPS="curl debootstrap grub-pc qemu-utils parted uuid-runtime linux-image-amd64" \
  && apt-get update && apt-get install -yq ${DEPS} \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -sSL http://url.muflone.com/VMware-ovftool-4.3.0-7948156-lin.x86_64.bundle > /tmp/ovftool.bundle \
  && chmod +x /tmp/ovftool.bundle && echo -n "\n" | /tmp/ovftool.bundle --eulas-agreed \
  && rm -rf /tmp/*
