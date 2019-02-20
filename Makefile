IMAGE_NAME=stage-3

stage2_scripts:=scripts/debian/stage-2.sh
stage3_scripts:=$(shell find scripts/debian/configure-* -type file -name '*.sh')
stage4_scripts:=$(shell find scripts/debian/post-* -type file -name '*.sh')

shell:
	@docker run -it --rm --privileged \
		-v $(PWD):/workspace -v $(PWD)/scripts/debian:/scripts \
		$(IMAGE_NAME) bash

$(stage2_scripts):
	@: # DO NOTHING

$(stage3_scripts):
	@: # DO NOTHING

$(stage4_scripts):
	@: # DO NOTHING

build: .stage-1 .stage-2 .stage-3 .stage-4
	docker build -t $(IMAGE_NAME) .

.stage-1: Dockerfile.stage-1
	@$(eval STAGE_NAME:=stage-1)
	docker build -f Dockerfile.$(STAGE_NAME) -t $(STAGE_NAME) .
	touch .$(STAGE_NAME)

.stage-2: $(stage2_scripts) .stage-1 Dockerfile.stage-2
	@$(eval STAGE_NAME:=stage-2)
	@docker rm -f $(STAGE_NAME) 2> /dev/null || true
	@docker run --name=$(STAGE_NAME) -i --privileged \
		-v $(PWD)/scripts/debian:/scripts \
		stage-1 bash /scripts/$(STAGE_NAME).sh
	@docker commit $(STAGE_NAME) $(STAGE_NAME)
	@docker rm $(STAGE_NAME)
	docker build -f Dockerfile.$(STAGE_NAME) -t $(STAGE_NAME) .
	@touch .$(STAGE_NAME) # Mark as newer than scripts

.stage-3: $(stage3_scripts) .stage-2 Dockerfile.stage-3
	@$(eval STAGE_NAME:=stage-3)
	@docker rm -f $(STAGE_NAME) 2> /dev/null || true
	@docker run --name=$(STAGE_NAME) -i --privileged \
		-v $(PWD)/scripts/debian:/scripts \
		stage-2 bash /scripts/$(STAGE_NAME).sh
	@docker commit $(STAGE_NAME) $(STAGE_NAME)
	@docker rm $(STAGE_NAME)
	@touch .$(STAGE_NAME)

.stage-4: $(stage4_scripts) .stage-3 Dockerfile.stage-4
	@$(eval STAGE_NAME:=stage-4)
	@docker rm -f $(STAGE_NAME) 2> /dev/null || true
	@docker run --name=$(STAGE_NAME) -i --privileged \
		-v $(PWD)/scripts/debian:/scripts \
		stage-3 bash /scripts/$(STAGE_NAME).sh
	@docker commit $(STAGE_NAME) $(STAGE_NAME)
	@docker rm $(STAGE_NAME)
	@touch .$(STAGE_NAME)
