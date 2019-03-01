curl -fsSL  https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update
# for ipvs mode, nfs storage support
apt-get install -y \
    ipvsadm ipset \
    nfs-common \
    kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
