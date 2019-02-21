#!/bin/bash
source /scripts/common-env.sh
source /scripts/common-snapshot.sh
source /scripts/common-load.sh

source /scripts/$1.sh

source /scripts/common-clean.sh
