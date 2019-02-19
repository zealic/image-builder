IMAGE_NAME=dmg

build: build.cache
	docker build -t $(IMAGE_NAME) .

build.cache: Dockerfile.stage-1 Dockerfile.stage-2
	touch build.cache

build-stage-1: build.cache
	@$(eval STAGE_NAME:=stage-1)
	docker build -f Dockerfile.$(STAGE_NAME) -t $(STAGE_NAME) .

build-stage-2: build.cache
	@$(eval STAGE_NAME:=stage-2)
	@docker rm -f $(STAGE_NAME) 2> /dev/null || true
	docker run --name=stage-2 -i --privileged \
	$(IMAGE_NAME) bash /scripts/$(STAGE_NAME).sh
	@docker commit $(STAGE_NAME) $(STAGE_NAME)
	@docker rm $(STAGE_NAME)
	docker build -f Dockerfile.$(STAGE_NAME) -t $(STAGE_NAME) .


shell:
	# privileged: debootstrap need mount /proc to target
	docker run -it --rm --privileged $(IMAGE_NAME)
