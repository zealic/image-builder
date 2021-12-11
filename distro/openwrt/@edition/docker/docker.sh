opkg update

# Install docker
opkg install dockerd docker docker-compose --force-postinstall

# NFS
opkg install nfs-utils kmod-fs-nfs-common kmod-fs-nfs-v3 kmod-fs-nfs-v4

cat > /etc/config/dockerd <<EOF
config globals 'globals'
        option data_root '/opt/docker/'
        option log_level 'warn'
        option iptables '1'
        list registry_mirrors 'https://docker.mirrors.ustc.edu.cn'

config firewall 'firewall'
        option device 'docker0'
        list blocked_interfaces 'wan'
EOF
