.DEFAULT_GOAL:=debian:exec
DISTRO_MAKE=make -f
BUILD_DIR=.build
SPECS_DIR=$(BUILD_DIR)/specs
ARTIFACTS_DIR=$(BUILD_DIR)artifacts

%:
	$(eval DISTRO_NAME:=$(firstword $(subst :, ,$*)))
	$(eval SUBCMD:=$(subst $(DISTRO_NAME):, ,$*))
	@make generate-$(DISTRO_NAME)
	make -f ./$(SPECS_DIR)/$(DISTRO_NAME)/Makefile.mk $(SUBCMD)

generate-%:
	@bash templates/generate.sh $*

clean:
	@rm -rf ./$(SPECS_DIR) ./$(ARTIFACTS_DIR)
