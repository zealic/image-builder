{{ $distro := (ds "distro") -}}
{{ $stages := $distro.stages | coll.Sort -}}
COMPOSE=docker-compose --log-level CRITICAL -f {{ $distro.dirs.config }}/compose.yml

exec:
	@qemu-system-x86_64 -hda {{ $distro.dirs.disks }}/disk.post.qcow2 -m 512

builder:
	@docker build -t {{ $distro.builder }} -f {{ $distro.dirs.config }}/Dockerfile .

build: builder {{- range $i, $name := $stages }} {{ $name }}{{ end }} post-stage

artifacts: artifact-vmdk artifact-ova

artifact-vmdk:
	@$(COMPOSE) run --rm artifact-vmdk

artifact-ova:
	@$(COMPOSE) run --rm artifact-ova

stage-%:
	@$(COMPOSE) run --rm stage-$*

post-stage:
	@$(COMPOSE) run --rm post-stage
