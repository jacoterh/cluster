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

while true; do

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

          # find the hold reason
          holdreason=$(condor_q -long $job | grep "HoldReason =")

          # modify resources and release job depending on the hold reason
          if [[ $holdreason == *"MaxWallTime"* ]]; then
              echo "Job exceed max walltime, resubmitting on long"
              condor_qedit "$job" JobCategory "long"
              condor_qedit "$job" MaxWallTime 345600
              condor_qedit "$job" JobCategoryDefaultWallTime 345600
              condor_qedit "$job" JobCategoryMaxWallTime 345600
          else
              echo "Job exceed max memory, incrementing memory"

              # find the current memory
              memory=$(condor_q -long $job | grep "RequestMemory =" | awk '{print $3}')

              # increment memory by 2gb
              new_memory=$((memory + 2048))

              # if new_memory is greater than 32gb, continue
              if [[ $new_memory -lt 32768 ]]; then
                  echo "Setting memory to $new_memory"
                  condor_qedit "$job" RequestMemory new_memory
              else
                  echo "Job exceeds max memory, skipping the release of this job"
                  continue  # skip to next job
              fi
          fi

          condor_release "$job"
      else
          echo "Not a MATRIX job, skipping"
      fi

  done
  sleep 10
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
