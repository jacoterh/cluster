#!/bin/bash
# This is a script to download, modify, and upload theory files to the cernbox

PASSWORD=""
PATH_TO_TTBAR="/data/theorie/jthoeve/physics_projects/theories_slim/data/fktables"

THEORIES=(40009000 40010001 40010002 40010003 40010004 40010005 40010006 40010007 40010008 40010009 40010010 40010011 40010012)

for i in "${THEORIES[@]}"; do

    echo "Processing theory_${i}..."
    # Download the theory_4000x000.tgz file
    curl -u :$PASSWORD -o "theory_${i}.tgz" "https://cernbox.cern.ch/remote.php/dav/public-files/MsBioAS1FShShI9/theory_${i}.tgz?signature=f59683a0c2f9d67e4c7efca76398e4345981ca949002cb05f2fe69c5c1350f25&expiration=2025-05-08T15%3A39%3A56%2B02%3A00" -#

    # make a backup
    cp "theory_${i}.tgz" "theory_${i}_backup.tgz"
    # Extract the contents of the theory_4000x000.tgz file
    tar -xzf "theory_${i}.tgz"

    echo "Copying new ttbar files to theory_${i}..."
    # copy ttbar to the theory
    cp "${PATH_TO_TTBAR}/${i}"/* "theory_${i}/fastkernel/"

    # remove .tgz file
    rm "theory_${i}.tgz"

    # zip again
    echo "Creating new theory_${i}.tgz file..."
    tar -czf "theory_${i}.tgz" "theory_${i}"

    # remove the theory folder
    rm -rf "theory_${i}"

    echo "Uploading theory_${i}.tgz to CERNBox..."
    # upload the theory
    curl -u :$PASSWORD -T "theory_${i}.tgz" "https://cernbox.cern.ch/remote.php/dav/public-files/MsBioAS1FShShI9/theory_${i}.tgz?signature=f59683a0c2f9d67e4c7efca76398e4345981ca949002cb05f2fe69c5c1350f25&expiration=2025-05-08T15%3A39%3A56%2B02%3A00" -#

    rm "theory_${i}.tgz"

done
