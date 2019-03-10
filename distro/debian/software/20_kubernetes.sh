curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

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

# helm
HELM_VER=2.13.0
HELM_URL=https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VER}-linux-amd64.tar.gz
curl -fsSL "${HELM_URL}" \
    | tar --strip-components=1 -xvzf - -C /tmp
mv /tmp/{helm,tiller} /usr/local/bin/
