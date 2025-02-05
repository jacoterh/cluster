import os
import sys
import subprocess
import shutil


def main(input_filename):
    try:
        # Define paths
        fitname = input_filename.split('.')[0]

        fits_folder = "/data/theorie/jthoeve/physics_projects/nnpdf_fits"
        source_file = f"{fits_folder}/scripts/workflow.dag"
        target_file = f"{fitname}.dag"

        # Check if source file exists
        if not os.path.exists(source_file):
            print(f"Error: Source file '{source_file}' does not exist.")
            sys.exit(1)

        # Copy and replace placeholder
        with open(source_file, 'r') as src:
            content = src.read().replace("runcardname", input_filename)
            content = content.replace("fitname", fitname)
        target_file_path = f"{fits_folder}/dagman/{target_file}"
        with open(target_file_path, 'w') as tgt:
            tgt.write(content)

        print(f"Generated DAG file: {target_file}")

        for subfile in ["setupfit.submit", "n3fit.submit", "evolven3fit.submit"]:
            shutil.copy(f"{fits_folder}/scripts/{subfile}", f"{fits_folder}/dagman/{fitname}-{subfile}")

        # Run condor_submit_dag command
        try:
            print(f"Submitting DAG file: {target_file}")
            subprocess.run(["condor_submit_dag", "-UseDagDir", "-MaxIdle", "20", target_file_path], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error running condor_submit_dag: {e}")
            sys.exit(1)

    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    # Check for command-line arguments
    if len(sys.argv) != 2:
        print("Usage: python submit_dag.py <filename>")
        sys.exit(1)

    input_filename = sys.argv[1]
    main(input_filename)
