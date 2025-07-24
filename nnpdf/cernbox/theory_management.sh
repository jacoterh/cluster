#!/bin/bash

PASSWORD=""
PATH_TO_TTBAR="/data/theorie/jthoeve/physics_projects/theories_slim/data/fktables"

#THEORIES=(40011000 40011001 40011002 40011003 40011004 40011005 40011006 40011007 40011008 40011009 40011010 40011011 40011012
#40012000 40012001 40012002 40012003 40012004 40012005 40012006 40012007 40012008 40012009 40012010 40012011 40012012)

THEORIES=(40010000 40010001 40010002 40010003 40010004 40010005 40010006 40010007 40010008 40010009 40010010 40010011 40010012)

for i in "${THEORIES[@]}"; do

    echo "Downloading theory_${i}..."
    # Download the theory_4000x000.tgz file
    curl -u :$PASSWORD -o "theory_${i}.tgz" "https://cernbox.cern.ch/remote.php/dav/public-files/MsBioAS1FShShI9/theory_${i}.tgz?signature=f59683a0c2f9d67e4c7efca76398e4345981ca949002cb05f2fe69c5c1350f25&expiration=2025-05-08T15%3A39%3A56%2B02%3A00" -#

    # make a backup
    echo "Backing up theory_${i}..."
    cp "theory_${i}.tgz" "theory_${i}_backup.tgz"
    # Extract the contents of the theory_4000x000.tgz file
    echo "Extract tar file theory_${i}..."
    tar -xzf "theory_${i}.tgz"

    echo "Copying new ttbar files to theory_${i} (only if missing)..."

    # Copy each file only if it doesn't already exist
    for file in "${PATH_TO_TTBAR}/${i}"/*; do
        target="theory_${i}/fastkernel/$(basename "$file")"
        if [ ! -e "$target" ]; then
            echo "Copying $(basename "$file") to theory_${i}..."
            cp "$file" "$target"
        else
            echo "Skipping $(basename "$file") (already exists)"
        fi
    done

    echo "Removing old theory_${i}.tgz file..."
    # remove .tgz file
    rm "theory_${i}.tgz"

    # zip again
    echo "Creating new theory_${i}.tgz file..."
    tar -czf "theory_${i}.tgz" "theory_${i}"

    echo "Removing theory_${i} folder..."
    # remove the theory folder
    rm -rf "theory_${i}"

    echo "Uploading theory_${i}.tgz to CERNBox..."
    # upload the theory
    curl -u :$PASSWORD -T "theory_${i}.tgz" "https://cernbox.cern.ch/remote.php/dav/public-files/MsBioAS1FShShI9/theory_${i}.tgz?signature=f59683a0c2f9d67e4c7efca76398e4345981ca949002cb05f2fe69c5c1350f25&expiration=2025-05-08T15%3A39%3A56%2B02%3A00" -#

    rm "theory_${i}.tgz"

done

