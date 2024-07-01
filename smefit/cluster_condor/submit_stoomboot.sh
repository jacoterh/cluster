#!/bin/bash

ENV='smefit'
source ./utils.sh

function submit_ns () {

    # Heavy fits
    MODELS=('smefit_hllhc_yukawas' 'smefit_fcc_yukawas')
    EFTS=('HO')
    PTOS=('NLO')
    MODE='NS'

    for MOD in ${MODELS[@]}
        do
        for PTO in ${PTOS[@]}
            do
            for EFT in ${EFTS[@]}
                do
                RUNCARD_NAME=$MODE'_'$MOD'_'$PTO'_'$EFT
                submit_job $MODE $RUNCARD_NAME $NCORES $NREP
                done
            done
        done
}
submit_ns

