#!/bin/bash



# generate THEORY LIST in a loop
THEORY_LIST=()
for i in {0..11}; do
    THEORY_LIST+=($((40013000 + i)))
done



DISTRIBUTION_LIST_DIS=(
"NMC_NC_NOTFIXED_EM-F2"
"NMC_NC_NOTFIXED_P_EM-SIGMARED"
"SLAC_NC_NOTFIXED_P_EM-F2"
"SLAC_NC_NOTFIXED_D_EM-F2"
"BCDMS_NC_NOTFIXED_P_EM-F2"
"BCDMS_NC_NOTFIXED_D_EM-F2"
"CHORUS_CC_NOTFIXED_PB_NU-SIGMARED"
"CHORUS_CC_NOTFIXED_PB_NB-SIGMARED"
"NUTEV_CC_NOTFIXED_FE_NU-SIGMARED"
"NUTEV_CC_NOTFIXED_FE_NB-SIGMARED"
"HERA_NC_318GEV_EM-SIGMARED"
"HERA_NC_225GEV_EP-SIGMARED"
"HERA_NC_251GEV_EP-SIGMARED"
"HERA_NC_300GEV_EP-SIGMARED"
"HERA_NC_318GEV_EP-SIGMARED"
"HERA_CC_318GEV_EM-SIGMARED"
"HERA_CC_318GEV_EP-SIGMARED"
"HERA_NC_318GEV_EAVG_CHARM-SIGMARED"
"HERA_NC_318GEV_EAVG_BOTTOM-SIGMARED"
)

# Define the wrapper script for running smefit
WRAPPER_SCRIPT="run_combine_fonll.sh"

# Create the wrapper script
cat <<EOL > $WRAPPER_SCRIPT
#!/bin/bash
# Wrapper script for executing pineko

THEORY_ID=\$1
DISTRIBUTION=\$2

PINEKO=/project/theorie/jthoeve/miniconda3/envs/pineko/bin/pineko

\$PINEKO fonll combine \$THEORY_ID \$DISTRIBUTION --FFNS3 \$THEORY_ID"00" --FFN03 \$THEORY_ID"01" --FFNS4zeromass \$THEORY_ID"02" --FFNS4massive \$THEORY_ID"03" --FFN04 \$THEORY_ID"04" --FFNS5zeromass \$THEORY_ID"05" --FFNS5massive \$THEORY_ID"06"
EOL

# Make the wrapper script executable
chmod +x $WRAPPER_SCRIPT

# Create the HTCondor submit description file
cat <<EOL > submit_pineko_combine_fonll.submit
# HTCondor submit file

universe = vanilla
executable = $WRAPPER_SCRIPT

# Transfer input files (the runcards)
arguments = \$(Item1) \$(Item2)

+UseOS                  = "el9"
+JobCategory            = "short"
request_cpus   = 1
request_memory = 8G
getenv = true
accounting_group = smefit

# Define log, output, and error files
log = logs/\$(Cluster)_\$(Process).log
output = logs/\$(Cluster)_\$(Process).out
error = logs/\$(Cluster)_\$(Process).err

max_idle = 20

# Queue jobs for each runcard
queue Item1, Item2 from (
EOL

# Append runcard list to the submit file
for THEORY in "${THEORY_LIST[@]}"; do
  echo $THEORY
  for DIST in "${DISTRIBUTION_LIST_DIS[@]}"; do

    echo "$THEORY $DIST" >> submit_pineko_combine_fonll.submit
  done
done

echo ")" >> submit_pineko_combine_fonll.submit

# Submit the jobs
#condor_submit submit_pineko.submit


