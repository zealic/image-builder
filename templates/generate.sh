#!/bin/bash
DISTRO_NAME=${1:-debian}
DISTRO_DIR=distro/${DISTRO_NAME}
SPEC_DIR=.specs/${DISTRO_NAME}
TEMPLATE_DIR=templates
DISKS_DIR=$SPEC_DIR/disks
ARTIFACTS_DIR=artifacts

# Check disto
mkdir -p "$SPEC_DIR"
if [[ ! -d "${DISTRO_DIR}" ]] || [[ "${DISTRO_NAME}" == "common" ]]; then
  echo "Invalid distro name '${DISTRO_NAME}'"
  exit 1
fi

FILE_DISTRO=$SPEC_DIR/distro.yml
cat > $FILE_DISTRO <<EOF
name: "$DISTRO_NAME"
builder: "${DISTRO_NAME}-image-builder:fake"
mirrors:
  debian: mirrors.ustc.edu.cn
dirs:
  spec: "${SPEC_DIR}"
  artifacts: "${ARTIFACTS_DIR}"
  disks: "${DISKS_DIR}"
pipelines:
EOF

gen_pipeline() {
  local name=$1
  local dir=distro/${DISTRO_NAME}/$1

  if [[ ! -e $dir/@metadata.yml ]]; then
    return
  fi
  echo "  - name: $name" >> $FILE_DISTRO
  cat $dir/@metadata.yml | sed 's/^/    /' >> $FILE_DISTRO
  echo "    items:" >> $FILE_DISTRO
  find $dir -type file -name '*.sh' \
    | xargs -I {} basename {} .sh | awk '{print "    - " "\"" $1 "\""}' >> $FILE_DISTRO
}

for pipeline in distro/${DISTRO_NAME}/*; do
  gen_pipeline $(basename $pipeline)
done

# Execute generate
echo Generating $DISTRO_NAME configuration...
gomplate -d distro=${FILE_DISTRO} \
    --input-dir=${TEMPLATE_DIR} --output-dir=${SPEC_DIR}
