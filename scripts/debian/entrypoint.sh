#!/bin/bash
source /scripts/common-env.sh
if [[ ! "$STAGE_NAME" == "stage-1" ]]; then
  source /scripts/common-snapshot.sh
  source /scripts/common-load.sh
fi

source /scripts/$STAGE_NAME.sh

source /scripts/common-clean.sh
