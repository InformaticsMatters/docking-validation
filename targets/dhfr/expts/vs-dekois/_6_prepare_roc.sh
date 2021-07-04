#!/bin/sh
# Usage: _6_prepare_roc.sh results.sdf score_field

set -e

echo Filtering results ...
sdsort -n -s -f$2 $1 | sdfilter -f'$_COUNT == 1' -s_TITLE1 > results_1poseperlig.sdf

echo Preparing data for ROC ...
sdreport -t$2 results_1poseperlig.sdf | awk '{print $2,$3}' > results_1poseperlig.txt

echo Done

