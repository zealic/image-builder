#!/bin/bash
DISTRO_NAME=${1:-debian}
DISTRO_DIR=distro/${DISTRO_NAME}
SPEC_DIR=.specs/${DISTRO_NAME}
TEMPLATE_DIR=templates
DISKS_DIR=$SPEC_DIR/disks
ARTIFACTS_DIR=artifacts
CI_PROJECT_NAMESPACE=${CI_PROJECT_NAMESPACE:-zealic}
CI_PROJECT_NAME=${CI_PROJECT_NAME:-$(basename ${PWD})}
CI_REGISTRY=${CI_REGISTRY:-docker.pkg.github.com}
CI_REGISTRY_IMAGE=${CI_REGISTRY_IMAGE:-${CI_REGISTRY}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}}

# Check disto
mkdir -p "$SPEC_DIR"
if [[ ! -d "${DISTRO_DIR}" ]] || [[ "${DISTRO_NAME}" == "common" ]]; then
  echo "Invalid distro name '${DISTRO_NAME}'"
  exit 1
fi

if [[ "${DISTRO_NAME}" == "centos" ]]; then
  DEVID=10
elif [[ "${DISTRO_NAME}" == "debian" ]]; then
  DEVID=11
elif  [[ "${DISTRO_NAME}" == "openwrt" ]]; then
  DEVID=12
else
  DEVID=1
fi

# Select mirrors by country
COUNTRY=$(curl -sSL ifconfig.co/country)
case $COUNTRY in
  "Hong Kong"|China)
    DEBIAN_MIRROR=mirrors.ustc.edu.cn
    ;;
  *)
    DEBIAN_MIRROR=deb.debian.org
    ;;
esac

gen_pipeline() {
  local dir=$1
  local name=$(basename $dir)

  if [[ ! -e $dir/@metadata.yml ]]; then
    return
  fi
  echo "  - name: $name"
  cat $dir/@metadata.yml | sed 's/^/    /'
  echo -e "\n    items:"
  find $dir -type f -name '*.sh' \
    | xargs -I {} basename {} .sh | awk '{print "    - " "\"" $1 "\""}'
}

gen_edition() {
  local dir=$1
  local name=$(basename $dir)

  echo "  - name: $name"
  echo -e "\n    items:"
  find $dir -type f -name '*.sh' \
    | xargs -I {} basename {} .sh | awk '{print "    - " "\"" $1 "\""}'
}

make_spec(){
  cat <<EOF
name: "$DISTRO_NAME"
devid: "$DEVID"
builder: "${CI_REGISTRY_IMAGE}/builder:${DISTRO_NAME}"
mirrors:
  debian: ${DEBIAN_MIRROR}
dirs:
  spec: "${SPEC_DIR}"
  artifacts: "${ARTIFACTS_DIR}"
  disks: "${DISKS_DIR}"
EOF

  echo "pipelines:"
  for pipeline in distro/${DISTRO_NAME}/*; do
    gen_pipeline $pipeline
  done

  echo "editions:"
  for edition in distro/${DISTRO_NAME}/@edition/*; do
    gen_edition $edition
  done
}

make_spec > $SPEC_DIR/distro.yml
# Execute generate
echo Generating $DISTRO_NAME configuration...
docker run -i --rm \
  -v "$PWD/${TEMPLATE_DIR}:/input" -v "$PWD/${SPEC_DIR}:/spec" \
  hairyhenderson/gomplate:v3 \
    -d distro=/spec/distro.yml --input-dir=/input --output-dir=/spec
