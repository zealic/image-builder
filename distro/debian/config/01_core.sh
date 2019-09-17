apt-get install -yq \
  sudo coreutils binutils e2fsprogs systemd systemd-sysv

# Locale
cat > /etc/default/locale <<EOF
LANG=C.UTF-8
LC_ALL=C.UTF-8
EOF
