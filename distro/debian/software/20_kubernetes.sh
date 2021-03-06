# kubernetes
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat >/etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

KUBE_VER=1.20
apt-get update
# for ipvs mode, nfs storage support
apt-get install -y \
    ipvsadm ipset \
    nfs-common \
    kubelet=${KUBE_VER}.* kubeadm=${KUBE_VER}.* kubectl=${KUBE_VER}.*
apt-mark hold kubelet kubeadm kubectl


# helm
HELM_VER=3.5
curl -fsSL https://baltocdn.com/helm/signing.asc | apt-key add -
cat >/etc/apt/sources.list.d/helm-stable-debian.list <<EOF
deb https://baltocdn.com/helm/stable/debian/ all main
EOF
apt-get update
apt-get install helm=${HELM_VER}.*
