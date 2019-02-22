#!/bin/bash
source /scripts/common/common-env.sh
if [[ -z "$PIPELINE_ROOT_JOB" ]]; then
  source /scripts/common/common-snapshot.sh
  source /scripts/common/common-load.sh
fi

JOB_FILE=/scripts/pipelines/$PIPELINE_NAME/$PIPELINE_JOB.sh
if [[ -e $JOB_FILE ]]; then
  if [[ -z $CHROOT ]]; then
    source $JOB_FILE
  else # chroot run
    set -e
    cp $JOB_FILE $TARGET_DIR/tmp/$PIPELINE_JOB.sh
    chroot $TARGET_DIR bash /tmp/$PIPELINE_JOB.sh
    rm $TARGET_DIR/tmp/$PIPELINE_JOB.sh
  fi
fi

source /scripts/common/common-clean.sh
