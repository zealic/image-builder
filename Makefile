IMAGE_NAME=dmg

scripts:=$(shell find scripts -type file -name '*.sh')


shell:
	@docker run -it --rm --privileged \
		-v $(PWD):/workspace \
		-v $(PWD)/grub-probe-hook:/usr/local/sbin/grub-probe \
		$(IMAGE_NAME) bash

$(scripts):
	@: # DO NOTHING

build: .stage-1 .stage-2
	docker build -t $(IMAGE_NAME) .

.stage-1: Dockerfile.stage-1
	@$(eval STAGE_NAME:=stage-1)
	docker build -f Dockerfile.$(STAGE_NAME) -t $(STAGE_NAME) .
	touch .$(STAGE_NAME)

.stage-2: $(scripts) .stage-1 Dockerfile.stage-2
	@$(eval STAGE_NAME:=stage-2)
	@docker rm -f $(STAGE_NAME) 2> /dev/null || true
	@docker run --name=$(STAGE_NAME) -i --privileged \
		-v $(PWD)/scripts/debian:/scripts \
		stage-1 bash /scripts/$(STAGE_NAME).sh
	@docker commit $(STAGE_NAME) $(STAGE_NAME)
	@docker rm $(STAGE_NAME)
	docker build -f Dockerfile.$(STAGE_NAME) -t $(STAGE_NAME) .
	@touch .$(STAGE_NAME) # Mark as newer than scripts
