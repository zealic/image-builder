# kubernetes
curl -fsSL "${KUBERNETES_KEY}" | apt-key add -
cat >/etc/apt/sources.list.d/kubernetes.list <<EOF
deb ${KUBERNETES_REPO} kubernetes-xenial main
EOF

KUBE_VER=1.22
apt-get update
# for ipvs mode, nfs storage support
apt-get install -y \
    ipvsadm ipset \
    nfs-common \
    kubelet=${KUBE_VER}.* kubeadm=${KUBE_VER}.* kubectl=${KUBE_VER}.*
apt-mark hold kubelet kubeadm kubectl


# helm
HELM_VER=3.7
curl -fsSL https://baltocdn.com/helm/signing.asc | apt-key add -
cat >/etc/apt/sources.list.d/helm-stable-debian.list <<EOF
deb https://baltocdn.com/helm/stable/debian/ all main
EOF
apt-get update
apt-get install helm=${HELM_VER}.*
