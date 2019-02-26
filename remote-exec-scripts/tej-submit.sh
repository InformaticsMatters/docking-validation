#!/bin/bash

set -e

if [ "$#" -ne 1 ]; then
  echo "ERROR: Must specify directory with content to submit as the only argument"
  exit 1
fi

SERVER=${SERVER}
SSH_KEY=$SSH_KEY
KNOWN_HOSTS=$KNOWN_HOSTS
POLL_INTERVAL=${POLL_INTERVAL:-10}
USERNAME=${USERNAME:-$USER}
DESTINATION=${USERNAME}@${SERVER}
DIR=$1
OUTPUTS="output.metadata output.data.gz output_metrics.txt report.html trace.txt"

echo "Submiting job from $DIR"

# start job
echo "Submitting Tej job using $DESTINATION ..."
JOB=$(tej submit $DESTINATION $DIR)
echo "Started Tej job $JOB"

while true
do
  STATUS=$(tej status $DESTINATION --id $JOB)
  echo "Status: $STATUS"
  if [ "$STATUS" == "running" ]; then
    sleep $POLL_INTERVAL			
  else
    break
  fi
done

echo "Job finished. Status: $STATUS"

if [ "$STATUS" == "finished 0" ]; then
  echo "Downloading results ..."
  cd $DIR
  tej download $DESTINATION --id $JOB $OUTPUTS
  echo "Results downloaded"
  echo "Deleting job ..."
  tej delete $DESTINATION --id $JOB
  echo "Job $JOB deleted"
else
  echo "Job did not complete successfully. Job is not deleted so this can be investigated."
fi

