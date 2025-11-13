#!/bin/bash

# condor_submit script for SMEFiT SCAN

# Define variables for the directory containing runcards
RUNCARD_DIR="<path/to/runcards/>"

# Generate a list of runcards in the directory
RUNCARD_LIST=$(ls $RUNCARD_DIR/*.yaml)

# Define the wrapper script for running smefit
WRAPPER_SCRIPT="run_scan.sh"

# Create the wrapper script
cat <<EOL > $WRAPPER_SCRIPT
#!/bin/bash
# Wrapper script for executing smefit SCAN

# Get the runcard file from the arguments
RUNCARD=\$1

# Run the smefit SCAN command
smefit SCAN --scan_points 100 \$RUNCARD
EOL

# Make the wrapper script executable
chmod +x $WRAPPER_SCRIPT

# Create the HTCondor submit description file
cat <<EOL > submit_file_scan.submit
# HTCondor submit file

universe = vanilla
executable = $WRAPPER_SCRIPT

# Transfer input files (the runcards)
arguments = \$(Item)

+UseOS                  = "el9"
+JobCategory            = "medium"
request_cpus   = 1
request_memory = 4G
getenv = true
accounting_group = smefit

# Define log, output, and error files
log = logs/smefit_scan_\$(Cluster)_\$(Process).log
output = logs/smefit_scan_\$(Cluster)_\$(Process).out
error = logs/smefit_scan_\$(Cluster)_\$(Process).err

# Queue jobs for each runcard
queue Item from (
EOL

# Append runcard list to the submit file
for RUNCARD in $RUNCARD_LIST; do
  echo "$RUNCARD" >> submit_file_scan.submit
done

echo ")" >> submit_file_scan.submit

# Submit the jobs
#condor_submit submit_file_scan.submit
