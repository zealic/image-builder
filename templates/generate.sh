#!/bin/bash
DISTRO_NAME=${1:-debian}
DISTRO_DIR=distro/${DISTRO_NAME}
BUILD_DIR=.build
SPEC_DIR=${BUILD_DIR}/specs/${DISTRO_NAME}
TEMPLATE_DIR=templates
DISKS_DIR=${SPEC_DIR}/disks
ARTIFACTS_DIR=${BUILD_DIR}/artifacts
CI_PROJECT_NAMESPACE=${CI_PROJECT_NAMESPACE:-zealic}
CI_PROJECT_NAME=${CI_PROJECT_NAME:-$(basename ${PWD})}
CI_REGISTRY=${CI_REGISTRY:-docker.pkg.github.com}
CI_REGISTRY_IMAGE=${CI_REGISTRY_IMAGE:-${CI_REGISTRY}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}}

# Distro versions
DEBIAN_CODENAME=bookworm
DEBIAN_VER=12
OPENWRT_VER=23.05.3

# Check disto
mkdir -p "$SPEC_DIR"
if [[ ! -d "${DISTRO_DIR}" ]] || [[ "${DISTRO_NAME}" == "common" ]]; then
  echo "Invalid distro name '${DISTRO_NAME}'"
  exit 1
fi

if [[ "${DISTRO_NAME}" == "debian" ]]; then
  DEVID=11
elif [[ "${DISTRO_NAME}" == "openwrt" ]]; then
  DEVID=12
else
  DEVID=1
fi

gen_pipeline(){
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

gen_edition(){
  local dir=$1
  local name=$(basename $dir)

  echo "  - name: $name"
  echo -e "\n    items:"
  find $dir -type f -name '*.sh' \
    | xargs -I {} basename {} .sh | awk '{print "    - " "\"" $1 "\""}'
}

make_env(){
  local country=$(curl -sSL ifconfig.co/country)

  echo "environment:"
  if [[ "${country}" =~ ^(China|Hong Kong)$ ]]; then
    make_env_${DISTRO_NAME}_cn
  else
    make_env_${DISTRO_NAME}
  fi
}

make_env_debian(){
  cat <<EOF
  DISTRO_VER: "${DEBIAN_VER}"
  DEBIAN_CODENAME: "${DEBIAN_CODENAME}"
  DEBIAN_MIRROR: "deb.debian.org"
  KUBERNETES_REPO: "https://apt.kubernetes.io/"
  KUBERNETES_KEY: "https://packages.cloud.google.com/apt/doc/apt-key.gpg"
EOF
}

make_env_debian_cn(){
  cat <<EOF
  DISTRO_VER: "${DEBIAN_VER}"
  DISTRO_SUFFIX: "-cn"
  DEBIAN_CODENAME: "${DEBIAN_CODENAME}"
  DEBIAN_MIRROR: "mirrors.ustc.edu.cn"
  KUBERNETES_REPO: "https://mirrors.aliyun.com/kubernetes/apt/"
  KUBERNETES_KEY: "https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg"
EOF
}

make_env_openwrt(){
  cat <<EOF
  DISTRO_VER: "${OPENWRT_VER}"
  OPENWRT_MIRROR: "downloads.openwrt.org"
EOF
}

make_env_openwrt_cn(){
  cat <<EOF
  DISTRO_VER: "${OPENWRT_VER}"
  DISTRO_SUFFIX: "-cn"
  OPENWRT_MIRROR: "mirrors.ustc.edu.cn/openwrt"
EOF
}

make_spec(){
  cat <<EOF
name: "$DISTRO_NAME"
devid: "$DEVID"
builder: "${CI_REGISTRY_IMAGE}/builder:${DISTRO_NAME}"
dirs:
  spec: "${SPEC_DIR}"
  artifacts: "${ARTIFACTS_DIR}"
  disks: "${DISKS_DIR}"
EOF
  make_env

  echo "pipelines:"
  for pipeline in distro/${DISTRO_NAME}/*; do
    gen_pipeline $pipeline
  done

  if [[ -d distro/${DISTRO_NAME}/@edition ]]; then
    echo "editions:"
    for edition in distro/${DISTRO_NAME}/@edition/*; do
      gen_edition $edition
    done
  else
    echo "editions: []"
  fi
}

make_spec > $SPEC_DIR/distro.yml
# Execute generate
echo Generating $DISTRO_NAME configuration...
docker run -i --rm \
  -v "$PWD/${TEMPLATE_DIR}:/input" -v "$PWD/${SPEC_DIR}:/spec" \
  hairyhenderson/gomplate:v3 \
    -d distro=/spec/distro.yml --input-dir=/input --output-dir=/spec
