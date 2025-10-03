#!/bin/bash
# Wrapper script for executing smefit NS

source ~/miniconda3/etc/profile.d/conda.sh
conda activate <smefit_env>

# Get the runcard file from the arguments
RUNCARD=$1

# Run the smefit NS command
smefit NS $RUNCARD
