FROM centos:8
# OVFTool UI required ncurses-compat-libs
RUN export MAIN_DEPS="curl grub2-pc qemu-img parted uuid kmod" \
  && export BUILDER_DEPS="ncurses-compat-libs e2fsprogs xfsprogs" \
  && yum install -y ${MAIN_DEPS} ${BUILDER_DEPS} \
  && yum clean all

ENV OVFTOOL_VER=4.3.0-7948156
ENV OVFTOOL_URL=https://raw.githubusercontent.com/smarunich/avitoolbox/master/files/VMware-ovftool-${OVFTOOL_VER}-lin.x86_64.bundle
RUN curl -sSL ${OVFTOOL_URL} > /tmp/ovftool.bundle \
  && chmod +x /tmp/ovftool.bundle \
  && echo -n "\n" | /tmp/ovftool.bundle --eulas-agreed \
  && rm -rf /tmp/*
