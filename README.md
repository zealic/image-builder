# Image Builder

Build image boxes for develop, testing and deploy.

Build without packer and virtual machine, docker only.

All config are generated by **gomplate**.


## Supported Distribution

* Debian


## Build

Build Debian:

```shell
make debian:build
make debian:artifacts
```

Build OpenWRT:

```shell
make openwrt:build
make openwrt:artifacts
```


## Q&A

* Why can't build in Docker or DIND (Docker in Docker)?  
  You need run docker as privileged mode 
  and enable **nbd** kernel module on your host `modprobe nbd`.


## TODO

* Use guestmount to replace qemu-nbd, direct use vmdk

https://github.com/jtvd78/install-custom-centos
