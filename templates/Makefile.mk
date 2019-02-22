{{ $distro := (ds "distro") -}}
{{ $pipelines := ($distro.pipelines | coll.Sort "index") -}}
COMPOSE=docker-compose --log-level CRITICAL -f {{ $distro.dirs.config }}/compose.yml

exec:
	{{- $lastPipeline := (index $pipelines (math.Sub (len $pipelines) 1)) }}
	@qemu-system-x86_64 -hda {{ $distro.dirs.disks }}/pipeline.{{ $lastPipeline.name }}.qcow2 -m 512

exec%:
	$(eval DISTRO_NAME:=$(firstword $(subst :, ,$*)))
	$(eval PIPELINE_NAME:=$(subst :, ,$*))
	qemu-system-x86_64 -hda .config/debian/disks/pipeline.$(PIPELINE_NAME).qcow2 -m 512

builder:
	@docker build -t {{ $distro.builder }} -f {{ $distro.dirs.config }}/Dockerfile .


#===============================================================================
# Pipelines
build: builder{{ range $pipelines }} build-{{ .name }}{{ end }}
{{- range $pn, $pipeline := $pipelines }}
{{- $items := $pipeline.items | coll.Sort }}
build-{{ $pipeline.name }}:{{ range $items }} {{ $pipeline.name }}-{{ .}}{{ end }} pipeline-{{ $pipeline.name }}
{{ $pipeline.name }}-%:
	@$(COMPOSE) run --rm {{ $pipeline.name }}-$*
{{- end }}
pipeline-%:
	@$(COMPOSE) run --rm pipeline-$*


#===============================================================================
# artifacts
artifacts: artifact-vmdk artifact-ova

artifact-vmdk:
	@$(COMPOSE) run --rm artifact-vmdk

artifact-ova:
	@$(COMPOSE) run --rm artifact-ova

stage-%:
	@$(COMPOSE) run --rm stage-$*

post-stage:
	@$(COMPOSE) run --rm post-stage
