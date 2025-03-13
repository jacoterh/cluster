#!/bin/bash

# This script deletes all files in the execution directory of held MATRIX jobs and releases them
# It also sets the job category to "long"

#1: Idle
#2: Running
#3: Removed
#4: Completed
#5: Held
#6: Submission Error

# Command to get held jobs' ClusterId.ProcId
jobs=$(condor_q jthoeve -constraint 'JobStatus == 5' -af ClusterId)

# Loop over each job ID
for job in $jobs; do
    echo "Processing job $job"

    userlog=$(condor_q -long $job | grep "UserLog" | awk '{print $3}')

    # only release MATRIX jobs
    if [[ $userlog == *"MATRIX/run/ppttx20_MATRIX"* ]]; then
        # remove trailing log/...
        trimmed_path="${userlog%/log/*}"
        # remove leading "
        trimmed_path="${trimmed_path#\"}"

        execution_dir="$trimmed_path/execution"
        rm $execution_dir/*
        echo "Removed all files in $execution_dir"

        #condor_qedit "$job" RequestMemory 16384
        condor_qedit "$job" JobCategory "long"
        condor_qedit "$job" MaxWallTime 345600
        condor_qedit "$job" JobCategoryDefaultWallTime 345600
        condor_qedit "$job" JobCategoryMaxWallTime 345600

        condor_release "$job"
    else
        echo "MATRIX not found in $log"
    fi

done

# TO PUT JOBS ON HOLD

#jobs=$(condor_q jthoeve -constraint 'JobStatus == 1' -af ClusterId)
#
## Loop over each job ID
#for job in $jobs; do
#    echo "Processing job $job"
#
#    condor_hold "$job"
#
#    echo "Job $job put on hold"
#done
