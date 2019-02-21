COMPOSE=docker-compose

vm:
	@qemu-system-x86_64 -hda disk.qcow2 -m 512

build: stage-1 stage-2 stage-3 stage-end

stage-%:
	@$(COMPOSE) run --rm stage-$*

generate-ova:
	@$(COMPOSE) run --rm generate-ova
