{{ $distro := (ds "distro") -}}
{{ $pipelines := ($distro.pipelines | coll.Sort "order") -}}
COMPOSE=docker-compose -f {{ $distro.dirs.spec }}/compose.yml
QEMU=qemu-system-x86_64 -smp 2 -m 512

exec:
	{{- $lastPipeline := (index $pipelines (math.Sub (len $pipelines) 1)) }}
	@cd {{ $distro.dirs.disks }}; qemu-img create -f qcow2 -b pipeline.{{ $lastPipeline.name }}.qcow2 exec.qcow2
	$(QEMU) -hda {{ $distro.dirs.disks }}/exec.qcow2

exec%:
	$(eval DISTRO_NAME:=$(firstword $(subst :, ,$*)))
	$(eval PIPELINE_NAME:=$(subst :, ,$*))
	@cd {{ $distro.dirs.disks }}; qemu-img create -f qcow2 -b pipeline.$(PIPELINE_NAME).qcow2 exec.$(PIPELINE_NAME).qcow2
	$(QEMU) -hda {{ $distro.dirs.disks }}/exec.$(PIPELINE_NAME).qcow2

builder:
	@docker build -t {{ $distro.builder }} -f {{ $distro.dirs.spec }}/Dockerfile .


#===============================================================================
# Pipelines
build: builder{{ range $pipelines }} build-{{ .name }}{{ end }}
{{- range $pn, $pipeline := $pipelines }}
{{- $items := $pipeline.items | coll.Sort }}
build-{{ $pipeline.name }}: pipeline-{{ $pipeline.name }}{{ range $items }} {{ $pipeline.name }}-{{ .}}{{ end }}
{{ $pipeline.name }}-%:
	@$(COMPOSE) run --rm {{ $pipeline.name }}-$*
{{- end }}
pipeline-%:
	@$(COMPOSE) run --rm pipeline-$*


#===============================================================================
# artifacts
artifacts: artifact-vmdk artifact-ova artifacts-ova-upload

artifact-vmdk:
	@$(COMPOSE) run --rm artifact-vmdk

artifact-ova:
	@$(COMPOSE) run --rm artifact-ova

artifacts-ova-upload:
	@$(COMPOSE) run --rm artifact-ova-upload
