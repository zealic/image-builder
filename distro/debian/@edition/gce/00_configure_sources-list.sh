mkdir -p /etc/apt/sources.list.d
cat > /etc/apt/sources.list.d/backports.list <<"EOF"
deb http://deb.debian.org/debian/ buster-backports main
deb-src http://deb.debian.org/debian/ buster-backports main
EOF

cat > /etc/apt/sources.list.d/google-cloud.list <<"EOF"
deb http://packages.cloud.google.com/apt cloud-sdk-buster main
deb http://packages.cloud.google.com/apt google-compute-engine-buster-stable main
deb http://packages.cloud.google.com/apt google-cloud-packages-archive-keyring-buster main
EOF
