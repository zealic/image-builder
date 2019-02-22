#!/bin/bash
source /scripts/common/common-env.sh
if [[ ! "$STAGE_NAME" == "stage-1" ]]; then
  source /scripts/common/common-snapshot.sh
  source /scripts/common/common-load.sh
fi

if [[ -e /scripts/stages/$STAGE_NAME.sh ]]; then
  source /scripts/stages/$STAGE_NAME.sh
fi

source /scripts/common/common-clean.sh
