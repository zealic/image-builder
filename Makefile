.DEFAULT_GOAL:=debian:exec
DISTRO_MAKE=make -f
SPECS_DIR=.build/specs
ARTIFACTS_DIR=artifacts

%:
	$(eval DISTRO_NAME:=$(firstword $(subst :, ,$*)))
	$(eval SUBCMD:=$(subst $(DISTRO_NAME):, ,$*))
	@make generate-$(DISTRO_NAME)
	make -f ./$(SPECS_DIR)/$(DISTRO_NAME)/Makefile.mk $(SUBCMD)

generate-%:
	@bash templates/generate.sh $*

clean:
	@rm -rf ./$(SPECS_DIR) ./$(ARTIFACTS_DIR)
