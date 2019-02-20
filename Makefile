IMAGE_NAME=stage-2

common_scripts:=$(shell find scripts/debian/common-* -type file -name '*.sh')

shell:
	@docker run -it --rm --privileged \
		-v $(PWD):/workspace -v $(PWD)/scripts/debian:/scripts \
		$(IMAGE_NAME) bash

$(common_scripts):
	@: # DO NOTHING

scripts/debian/stage-1.sh:
scripts/debian/stage-2.sh:
scripts/debian/stage-3.sh:

build: .stage-1 .stage-2 .stage-3
	docker build -t $(IMAGE_NAME) .

.stage-1: Dockerfile.stage-1 scripts/debian/stage-1.sh
	@$(eval STAGE_NAME:=stage-1)
	docker build -f Dockerfile.$(STAGE_NAME) -t $(STAGE_NAME) .
	touch .$(STAGE_NAME)

.stage-2: $(common_scripts) .stage-1 scripts/debian/stage-2.sh
	@$(eval STAGE_NAME:=stage-2)
	@docker rm -f $(STAGE_NAME) 2> /dev/null || true
	@docker run --name=$(STAGE_NAME) -i --privileged \
		-v $(PWD)/scripts/debian:/scripts \
		stage-1 bash /scripts/$(STAGE_NAME).sh
	@docker commit $(STAGE_NAME) $(STAGE_NAME)
	@docker rm $(STAGE_NAME)
	@touch .$(STAGE_NAME) # Mark as newer than scripts

.stage-3: $(common_scripts) .stage-2 scripts/debian/stage-3.sh
	@$(eval STAGE_NAME:=stage-3)
	@docker rm -f $(STAGE_NAME) 2> /dev/null || true
	@docker run --name=$(STAGE_NAME) -i --privileged \
		-v $(PWD)/scripts/debian:/scripts \
		stage-2 bash /scripts/$(STAGE_NAME).sh
	@docker commit $(STAGE_NAME) $(STAGE_NAME)
	@docker rm $(STAGE_NAME)
	@touch .$(STAGE_NAME) # Mark as newer than scripts
