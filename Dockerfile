FROM debian:9-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN export DEPS="debootstrap grub-pc qemu-utils parted uuid-runtime linux-image-amd64" \
  && apt-get update && apt-get install -yq ${DEPS} \
  && apt-get clean && rm -rf /var/lib/apt/lists/*
