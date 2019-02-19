IMAGE_NAME=dmg

scripts:=$(shell find scripts -type file -name '*.sh')


shell:
	@docker run -it --rm --privileged $(IMAGE_NAME)

$(scripts):
	@: # DO NOTHING

build: Dockerfile.stage-1 Dockerfile.stage-2
	docker build -t $(IMAGE_NAME) .

Dockerfile.stage-1:
	@$(eval STAGE_NAME:=stage-1)
	docker build -f Dockerfile.$(STAGE_NAME) -t $(STAGE_NAME) .

Dockerfile.stage-2: $(scripts) Dockerfile.stage-1
	@$(eval STAGE_NAME:=stage-2)
	@docker rm -f $(STAGE_NAME) 2> /dev/null || true
	docker run --name=stage-2 -i --privileged \
	$(IMAGE_NAME) bash /scripts/$(STAGE_NAME).sh
	@docker commit $(STAGE_NAME) $(STAGE_NAME)
	@docker rm $(STAGE_NAME)
	docker build -f Dockerfile.$(STAGE_NAME) -t $(STAGE_NAME) .
	@touch Dockerfile.stage-2 # Mark as newer than scripts
