#!/bin/bash

# condor_submit script for dataset selection alphas mtop

# Define the wrapper script for running smefit
WRAPPER_SCRIPT="run_produce_eko.sh"

# Create the wrapper script
cat <<EOL > $WRAPPER_SCRIPT
#!/bin/bash
# Wrapper script for executing smefit SCAN

source /project/theorie/jthoeve/miniconda3/etc/profile.d/conda.sh
conda activate nnpdf_dev

# Get the runcard file from the arguments
THEORY=\$1
OUTPUT_DIR=\$2

# Run the smefit produce_eko command
evolven3fit -n 64 produce_eko \$THEORY \$OUTPUT_DIR
EOL

# Make the wrapper script executable
chmod +x $WRAPPER_SCRIPT

# Create the HTCondor submit description file
cat <<EOL > submit_produce_eko.submit
# HTCondor submit file

universe = vanilla
executable = $WRAPPER_SCRIPT

# Transfer input files (the runcards)
arguments = \$(Item)

+UseOS                  = "el9"
+JobCategory            = "medium"
request_cpus   = 64
request_memory = 128G
getenv = true
accounting_group = smefit

# Define log, output, and error files
log = ../logs/produce_eko_\$(Cluster)_\$(Process).log
output = ../logs/produce_eko_\$(Cluster)_\$(Process).out
error = ../logs/produce_eko_\$(Cluster)_\$(Process).err

# Queue jobs for each runcard
queue Item from (
EOL

THEORIES=(40013005)
OUTPUT_DIR=/data/theorie/jthoeve/physics_projects/nnpdf_share/ekos

# Append runcard list to the submit file
for THEORY in "${THEORIES[@]}"; do
    echo "$THEORY ${OUTPUT_DIR}/eko_${THEORY}.tar" >> submit_produce_eko.submit
done

echo ")" >> submit_produce_eko.submit

# Submit the jobs
#condor_submit submit_file_scan.submit
