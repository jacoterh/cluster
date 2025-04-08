import numpy as np
import pathlib

crashed_runs = []
with open("ttbar_13tev_matrix.log") as f:
    lines = f.readlines()
    for i, line in enumerate(lines):
        if "failed; path:" in line:
            temp = [''.join(lines[i + 1:i + 4]).strip()][0].replace(" ", "").replace("\n", "")
            path_to_exec, channel = temp.split(",channel:")
            channel = channel.split(".Re")[0]
            path_to_exec = pathlib.Path(path_to_exec) / "execution" / "execution_{}.dat".format(channel)
            crashed_runs.append(path_to_exec)
crashed_runs_unique = set(crashed_runs)

for file in crashed_runs_unique:
    # if file exists
    if file.is_file():
        # remove file with subprocess
        print("Removing file: ", file)
        file.unlink()
        
