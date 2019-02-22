{{ $distro := (ds "distro") -}}
{{ $stages := $distro.stages | coll.Sort -}}
COMPOSE=docker-compose --log-level CRITICAL -f {{ $distro.dirs.config }}/compose.yml

exec:
	@qemu-system-x86_64 -hda {{ $distro.dirs.disks }}/disk.post.qcow2 -m 512

build: {{- range $i, $name := $stages }} {{ $name }}{{ end }} post-stage

generate-ova:
	@$(COMPOSE) run --rm generate-ova

stage-%:
	@$(COMPOSE) run --rm stage-$*

post-stage:
	@$(COMPOSE) run --rm post-stage
