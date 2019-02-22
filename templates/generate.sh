#!/bin/bash
DISTRO_NAME=${1:-debian}
DISTRO_DIR=distro/${DISTRO_NAME}
CONFIG_DIR=.config/${DISTRO_NAME}
TEMPLATE_DIR=templates
METADATA_DIR=$CONFIG_DIR/metadata
DISKS_DIR=$CONFIG_DIR/disks
ARTIFACTS_DIR=artifacts

# Check disto
if [[ ! -d "${DISTRO_DIR}" ]] || [[ "$DISTRO_NAME" == "common" ]]; then
  echo "Invalid distro name '$(DISTRO_NAME)'"
  exit 1
fi

mkdir -p $METADATA_DIR

FILE_DISTRO=$METADATA_DIR/distro.yml
cat > $FILE_DISTRO <<EOF
name: "$DISTRO_NAME"
dirs:
  config: "${CONFIG_DIR}"
  artifacts: "${ARTIFACTS_DIR}"
  disks: "${DISKS_DIR}"
stages:
EOF

find distro/${DISTRO_NAME}/stages -type file -name 'stage-*.sh' \
  | xargs -I {} basename {} .sh | awk '{print "  - " "\"" $1 "\""}' >> $FILE_DISTRO

# Execute generate
echo Generating $DISTRO_NAME configuration...
gomplate -d distro=${FILE_DISTRO} \
    --input-dir=${TEMPLATE_DIR} --output-dir=${CONFIG_DIR}
