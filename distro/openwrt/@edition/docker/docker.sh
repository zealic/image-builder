opkg update

# Install docker
opkg install dockerd docker docker-compose --force-postinstall

# NFS
opkg install nfs-utils kmod-fs-nfs-common kmod-fs-nfs-v3 kmod-fs-nfs-v4
