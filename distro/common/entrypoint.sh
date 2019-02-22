#!/bin/bash
source /scripts/common/common-env.sh
if [[ ! "$STAGE_NAME" == "stage-1" ]]; then
  source /scripts/common/common-snapshot.sh
  source /scripts/common/common-load.sh
fi

source /scripts/stages/$STAGE_NAME.sh

source /scripts/common/common-clean.sh
