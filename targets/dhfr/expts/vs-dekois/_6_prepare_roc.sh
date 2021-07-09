#!/bin/sh
#
# Usage: _6_prepare_roc.sh results.sdf score_field [num_poses]
# If num_poses is specified as the third argument then on that number of poses
# from the input file are used.

set -e

echo Filtering results ...

if [[ $# -eq 3 ]]; then
  sdfilter -f"\$_COUNT <= $3" -s_TITLE1 $1 | sdsort -n -s -f$2 | sdfilter -f'$_COUNT == 1' -s_TITLE1 > results_1poseperlig_from$3.sdf
else
  sdsort -n -s -f$2 $1 | sdfilter -f'$_COUNT == 1' -s_TITLE1 > results_1poseperlig.sdf
fi

echo Preparing data for ROC ...

if [[ $# -eq 3 ]]; then
  sdreport -t$2 results_1poseperlig_from$3.sdf | awk '{print $2,$3}' > results_1poseperlig_from$3.txt
else
  sdreport -t$2 results_1poseperlig.sdf | awk '{print $2,$3}' > results_1poseperlig.txt
fi

echo Done

