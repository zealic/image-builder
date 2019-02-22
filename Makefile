COMPOSE=docker-compose

exec-vm: exec-vm-Debian

exec-vm-%:
	@qemu-system-x86_64 -hda disks/$*.vmdk -m 512

build: stage-1 stage-2 stage-3 stage-end

stage-%:
	@$(COMPOSE) run --rm stage-$*

generate-ova:
	@$(COMPOSE) run --rm generate-ova
