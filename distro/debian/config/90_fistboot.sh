# Debian not support systemd-firstboot, need delete /etc/machine-id on post stage
# And add this service to generate machine-id on firstboot
# See also: https://bugzilla.redhat.com/show_bug.cgi?id=1379800
cat > /lib/systemd/system/sysinit.target.wants/regenerate-machineid.service <<EOF
[Unit]
Description=Generate New Machine ID
Documentation=man:systemd-machine-id-commit.service(8)
DefaultDependencies=no
Conflicts=shutdown.target
Before=systemd-tmpfiles-setup-dev.service systemd-journald.service systemd-sysusers.service sysinit.target shutdown.target
After=systemd-remount-fs.service
ConditionPathIsReadWrite=/etc
ConditionPathExists=/etc/.regen-machine-id

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/sh -c 'dbus-uuidgen > /etc/machine-id'
ExecStartPost=/bin/sh -c 'hostnamectl --static $(cut -c1-12 /etc/machine-id)'
ExecStartPost=/bin/sh -c 'rm /etc/.regen-machine-id'
TimeoutSec=30s
EOF

touch /etc/.regen-machine-id
