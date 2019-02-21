COMPOSE=docker-compose

vm:
	@qemu-system-x86_64 -hda disk.qcow2 -m 512

build: stage-1 stage-2 stage-end

stage-1:
	@$(COMPOSE) run --rm stage-1

stage-2:
	@$(COMPOSE) run --rm stage-2

stage-end:
	@$(COMPOSE) run --rm stage-end
