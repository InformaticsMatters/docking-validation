#!/bin/bash
# Example nextflow-complete.sh file that copies stats from the executed nextflow
# job to the ~/nf-jobs directory. Does not copy any inputs or outputs of the job.

path=$1
echo "Workflow $path completed"

dir=$(echo $path | rev | cut -d '/' -f 2 | rev)
echo $dir
dest="$HOME/nf-jobs/$dir"
mkdir -p "$dest"

for f in 'trace.txt' 'status.log' 'timeline.html' 'report.html' '.nextflow.log'\
 'output_metrics.txt' '_stdout' '_stderr'
do
  if [ -f "$path/$f" ]; then
    cp "$path/$f" "$dest"
  fi
done

