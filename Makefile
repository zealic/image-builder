.DEFAULT_GOAL:=debian-generate
DISTRO_MAKE=make -f

%:
	$(eval DISTRO_NAME:=$(firstword $(subst -, ,$*)))
	$(eval SUBCMD:=$(subst $(DISTRO_NAME)-, ,$*))
	make -f .config/$(DISTRO_NAME)/Makefile.mk $(SUBCMD)

%-generate:
	@bash templates/generate.sh $(DISTRO_NAME)

clean:
	@rm -rf .config artifacts
