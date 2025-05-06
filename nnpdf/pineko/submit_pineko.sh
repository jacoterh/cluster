#!/bin/bash

THEORY_LIST=(41000000)

DISTRIBUTION_LIST=(
ATLAS_TTBAR_13TEV_HADR_DIF_MTTBAR-NORM
ATLAS_TTBAR_13TEV_HADR_DIF_MTTBAR-YTTBAR-NORM
ATLAS_TTBAR_13TEV_HADR_DIF_YTTBAR-NORM
ATLAS_TTBAR_13TEV_LJ_DIF_MTTBAR-NORM
ATLAS_TTBAR_13TEV_LJ_DIF_MTTBAR-PTT-NORM
ATLAS_TTBAR_13TEV_LJ_DIF_PTT-NORM
ATLAS_TTBAR_13TEV_LJ_DIF_PTT-YT-NORM
ATLAS_TTBAR_13TEV_LJ_DIF_YT-NORM
ATLAS_TTBAR_13TEV_LJ_DIF_YTTBAR-NORM
ATLAS_TTBAR_13TEV_TOT_X-SEC
ATLAS_TTBAR_7TEV_TOT_X-SEC
ATLAS_TTBAR_8TEV_2L_DIF_MTTBAR-NORM
ATLAS_TTBAR_8TEV_2L_DIF_YTTBAR-NORM
ATLAS_TTBAR_8TEV_LJ_DIF_MTTBAR-NORM
ATLAS_TTBAR_8TEV_LJ_DIF_PTT-NORM
ATLAS_TTBAR_8TEV_LJ_DIF_YT-NORM
ATLAS_TTBAR_8TEV_LJ_DIF_YTTBAR-NORM
ATLAS_TTBAR_8TEV_TOT_X-SEC
CMS_TTBAR_13TEV_2L_DIF_MTTBAR-NORM
CMS_TTBAR_13TEV_2L_DIF_PTT-NORM
CMS_TTBAR_13TEV_2L_DIF_YT-NORM
CMS_TTBAR_13TEV_2L_DIF_YTTBAR-NORM
CMS_TTBAR_13TEV_LJ_DIF_MTTBAR-NORM
CMS_TTBAR_13TEV_LJ_DIF_MTTBAR-YTTBAR-NORM
CMS_TTBAR_13TEV_LJ_DIF_PTT-NORM
CMS_TTBAR_13TEV_LJ_DIF_YT-NORM
CMS_TTBAR_13TEV_LJ_DIF_YTTBAR-NORM
CMS_TTBAR_13TEV_TOT_X-SEC
CMS_TTBAR_5TEV_TOT_X-SEC
CMS_TTBAR_7TEV_TOT_X-SEC
CMS_TTBAR_8TEV_2L_DIF_MTTBAR-YT-NORM
CMS_TTBAR_8TEV_2L_DIF_MTTBAR-YTTBAR-NORM
CMS_TTBAR_8TEV_2L_DIF_PTT-YT-NORM
CMS_TTBAR_8TEV_LJ_DIF_MTTBAR-NORM
CMS_TTBAR_8TEV_LJ_DIF_PTT-NORM
CMS_TTBAR_8TEV_LJ_DIF_YT-NORM
CMS_TTBAR_8TEV_LJ_DIF_YTTBAR-NORM
CMS_TTBAR_8TEV_TOT_X-SEC
)

# Define the wrapper script for running smefit
WRAPPER_SCRIPT="run_pineko.sh"

# TODO: ADD OVERWRITE TO OPCARDS?

# Create the wrapper script
cat <<EOL > $WRAPPER_SCRIPT
#!/bin/bash
# Wrapper script for executing pineko

THEORY=\$1
DISTRIBUTION=\$2

#pineko theory opcards \$THEORY \$DISTRIBUTION
pineko theory ekos \$THEORY \$DISTRIBUTION
pineko theory fks \$THEORY \$DISTRIBUTION
EOL

# Make the wrapper script executable
chmod +x $WRAPPER_SCRIPT

# Create the HTCondor submit description file
cat <<EOL > submit_pineko.submit
# HTCondor submit file

universe = vanilla
executable = $WRAPPER_SCRIPT

# Transfer input files (the runcards)
arguments = \$(Item1) \$(Item2)

+UseOS                  = "el9"
+JobCategory            = "medium"
request_cpus   = 32
request_memory = 128G
getenv = true
accounting_group = smefit

# Define log, output, and error files
log = logs/\$(Cluster)_\$(Process).log
output = logs/\$(Cluster)_\$(Process).out
error = logs/\$(Cluster)_\$(Process).err

# Queue jobs for each runcard
queue Item1, Item2 from (
EOL

# Append runcard list to the submit file
for THEORY in "${THEORY_LIST[@]}"; do
  for DIST in "${DISTRIBUTION_LIST[@]}"; do

    echo "$THEORY $DIST" >> submit_pineko.submit
  done
done

echo ")" >> submit_pineko.submit

# Submit the jobs
#condor_submit submit_pineko.submit


