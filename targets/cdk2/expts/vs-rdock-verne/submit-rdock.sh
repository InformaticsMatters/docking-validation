#!/bin/bash

num=$1
echo "num is $num"
sep=""
jobids=""
for file in ligands_part*.sdf; do
    base="${file%.sdf}"
    core="${base#ligands_}"
    echo "Submitting job for $file $base $core"
    jobids=${jobids}${sep}$(qsub -terse -N docked_${core} -b y singularity exec ~/singularity-containers/rdock-mini-latest.simg rbdock -i $file -r cdk2_rdock.prm -p dock.prm -n $num -o docked_${core})
    sep=","
done
echo "Jobs $jobids submitted"
qsub -hold_jid ${jobids} -b y -N wait-for-rdock touch DONE
echo "Holding job submitted"

