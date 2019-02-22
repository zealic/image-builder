.DEFAULT_GOAL:=debian:exec
DISTRO_MAKE=make -f

%:
	$(eval DISTRO_NAME:=$(firstword $(subst :, ,$*)))
	$(eval SUBCMD:=$(subst $(DISTRO_NAME):, ,$*))
	@bash templates/generate.sh $(DISTRO_NAME)
	make -f .config/$(DISTRO_NAME)/Makefile.mk $(SUBCMD)

clean:
	@rm -rf .config artifacts
