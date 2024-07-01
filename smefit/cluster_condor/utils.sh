#!/bin/bash

PY='/project/theorie/jthoeve/miniconda3/envs/'$ENV'/bin/python'
MPI='/project/theorie/jthoeve/miniconda3/envs/'$ENV'/bin/mpiexec'
SMEFIT='/project/theorie/jthoeve/miniconda3/envs/'$ENV'/bin/smefit'
MULTINEST='/project/theorie/jthoeve/miniconda3/envs/'$ENV'/lib'
CONDA_SCRIPT_PATH="/project/theorie/jthoeve/miniconda3/etc/profile.d/conda.sh"

function submit_job () {

    # FIT SETUP
    MODE=$1
    FIT_ID=$2

    # create the bash file to submit
    COMMAND=$PWD'/launch_'$FIT_ID'.sh'
    cd ..
    ROOT_PATH=$PWD
    cd $PWD'/cluster_condor'
    OUT_PATH=$PWD'/logs'
    
    # this is the script to launch
    RUNCARD_PATH=$ROOT_PATH'/runcards/smefit_fcc'

    RUNCARD=$RUNCARD_PATH'/'$FIT_ID'.yaml'

    EXPORT='export LD_LIBRARY_PATH='$MULTINEST';'

    if [ $MODE == 'NS' ]
    then
        SMEFIT_ARGS='NS '$RUNCARD' -l '$OUT_PATH'/output_'$FIT_ID'.log;'
        EXE=$SMEFIT' '$SMEFIT_ARGS
    fi
    if [ $MODE == 'A' ]
    then
        NCORES=1
        SMEFIT_ARGS='A '$RUNCARD' -l '$OUT_PATH'/output_'$FIT_ID'.log;'
        EXE=$PY' '$SMEFIT' '$SMEFIT_ARGS
    fi
    if [ $MODE == 'R' ]
    then
        NCORES=1
        EXPORT='export LD_LIBRARY_PATH='$MULTINEST';source '$CONDA_SCRIPT_PATH';conda activate '$ENV';'
        SMEFIT_ARGS='R '$RUNCARD_REPORT
        EXE=$PY' '$SMEFIT' '$SMEFIT_ARGS
    fi

    LAUNCH=$EXPORT$EXE
    
    [ -e $COMMAND ] && rm $COMMAND
    mkdir -p $OUT_PATH
    echo $LAUNCH >> $COMMAND
    chmod +x $COMMAND

   # submission with condor
   condor_submit arg1=$FIT_ID condor_submit.sub

    # cleaning
    #rm $COMMAND

}
