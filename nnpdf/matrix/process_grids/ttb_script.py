import os, sys, subprocess

energy = sys.argv[1]
input = sys.argv[2]
output = sys.argv[3]

mttb = [
    "--set-key-value",
    "x1_label",
    "top pair mass",
    "--set-key-value",
    "x1_label_tex",
    "$m_{t\\bar{t}}$",
    "--set-key-value",
    "x1_unit",
    "GeV",
    "--set-key-value",
    "y_label",
    "differential x-sec",
    "--set-key-value",
    "y_label_tex",
    "$\\frac{d\\sigma}{dm_{t\\bar{t}}}$",
    "--set-key-value",
    "y_unit",
    "pb/GeV",
]

ptt = [
    "--set-key-value",
    "x1_label",
    "top transverse momentum",
    "--set-key-value",
    "x1_label_tex",
    "$pT_t$",
    "--set-key-value",
    "x1_unit",
    "GeV",
    "--set-key-value",
    "y_label",
    "differential x-sec",
    "--set-key-value",
    "y_label_tex",
    "$\\frac{d\\sigma}{dpT_t}$",
    "--set-key-value",
    "y_unit",
    "pb/GeV",
]

absyt = [
    "--set-key-value",
    "x1_label",
    "top abs rapidity",
    "--set-key-value",
    "x1_label_tex",
    "$|y_t|$",
    "--set-key-value",
    "x1_unit",
    "",
    "--set-key-value",
    "y_label",
    "differential x-sec",
    "--set-key-value",
    "y_label_tex",
    "$\\frac{d\\sigma}{d|y_t|}$",
    "--set-key-value",
    "y_unit",
    "pb",
]

yt = [
    "--set-key-value",
    "x1_label",
    "top rapidity",
    "--set-key-value",
    "x1_label_tex",
    "$y_t$",
    "--set-key-value",
    "x1_unit",
    "",
    "--set-key-value",
    "y_label",
    "differential x-sec",
    "--set-key-value",
    "y_label_tex",
    "$\\frac{d\\sigma}{dy_t}$",
    "--set-key-value",
    "y_unit",
    "pb",
]

absyttbar = [
    "--set-key-value",
    "x1_label",
    "top pair abs rapidity",
    "--set-key-value",
    "x1_label_tex",
    "$|y_{t\\bar{t}}|$",
    "--set-key-value",
    "x1_unit",
    "",
    "--set-key-value",
    "y_label",
    "differential x-sec",
    "--set-key-value",
    "y_label_tex",
    "$\\frac{d\\sigma}{d|y_{t\\bar{t}}|}$",
    "--set-key-value",
    "y_unit",
    "pb",
]

yttbar = [
    "--set-key-value",
    "x1_label",
    "top pair rapidity",
    "--set-key-value",
    "x1_label_tex",
    "$y_{t\\bar{t}}$",
    "--set-key-value",
    "x1_unit",
    "",
    "--set-key-value",
    "y_label",
    "differential x-sec",
    "--set-key-value",
    "y_label_tex",
    "$\\frac{d\\sigma}{dy_{t\\bar{t}}}$",
    "--set-key-value",
    "y_unit",
    "pb",
]

default = ["pineappl", "write", "--scale", "0.001"]

matrix_suffix = "_NNLO.QCD.pineappl.lz4"
new_suffix = ".pineappl.lz4"

gnf8, gnf13 = [], []


def process_8():

    ################# 1D distributions

    # ATLAS_TTBAR_8TEV_2L_DIF_MTTBAR
    input_path = input + "/ATLAS_TTBAR_8TEV_2L_DIF_MTTBAR" + matrix_suffix
    output_path = output + "/ATLAS_TTBAR_8TEV_2L_DIF_MTTBAR" + new_suffix
    if os.path.exists(input_path):
        subprocess.run(default + mttb + [input_path, output_path])
    else:
        gnf8.append(input_path)

    # ATLAS_TTBAR_8TEV_2L_DIF_YTTBAR
    input_path = input + "/ATLAS_TTBAR_8TEV_2L_DIF_YTTBAR" + matrix_suffix
    output_path = output + "/ATLAS_TTBAR_8TEV_2L_DIF_YTTBAR" + new_suffix
    if os.path.exists(input_path):
        subprocess.run(default + absyttbar + [input_path, output_path])
    else:
        gnf8.append(input_path)

    # ATLAS_TTBAR_8TEV_LJ_DIF_MTTBAR
    input_path = input + "/ATLAS_TTBAR_8TEV_LJ_DIF_MTTBAR" + matrix_suffix
    output_path = output + "/ATLAS_TTBAR_8TEV_LJ_DIF_MTTBAR" + new_suffix
    if os.path.exists(input_path):
        subprocess.run(default + mttb + [input_path, output_path])
    else:
        gnf8.append(input_path)

    # ATLAS_TTBAR_8TEV_LJ_DIF_YTTBAR
    input_path = input + "/ATLAS_TTBAR_8TEV_LJ_DIF_YTTBAR" + matrix_suffix
    output_path = output + "/ATLAS_TTBAR_8TEV_LJ_DIF_YTTBAR" + new_suffix
    if os.path.exists(input_path):
        subprocess.run(default + absyttbar + [input_path, output_path])
    else:
        gnf8.append(input_path)

    # ATLAS_TTBAR_8TEV_LJ_DIF_YT
    input_path = input + "/ATLAS_TTBAR_8TEV_LJ_DIF_YT" + matrix_suffix
    output_path = output + "/ATLAS_TTBAR_8TEV_LJ_DIF_YT" + new_suffix
    if os.path.exists(input_path):
        subprocess.run(default + absyt + [input_path, output_path])
    else:
        gnf8.append(input_path)

    # ATLAS_TTBAR_8TEV_LJ_DIF_PTT
    input_path = input + "/ATLAS_TTBAR_8TEV_LJ_DIF_PTT" + matrix_suffix
    output_path = output + "/ATLAS_TTBAR_8TEV_LJ_DIF_PTT" + new_suffix
    if os.path.exists(input_path):
        subprocess.run(default + ptt + [input_path, output_path])
    else:
        gnf8.append(input_path)

    # CMS_TTBAR_8TEV_LJ_DIF_MTTBAR
    input_path = input + "/CMS_TTBAR_8TEV_LJ_DIF_MTTBAR" + matrix_suffix
    output_path = output + "/CMS_TTBAR_8TEV_LJ_DIF_MTTBAR" + new_suffix
    if os.path.exists(input_path):
        subprocess.run(default + mttb + [input_path, output_path])
    else:
        gnf8.append(input_path)

    # CMS_TTBAR_8TEV_LJ_DIF_YTTBAR (catr)
    input_path = input + "/CMS_TTBAR_8TEV_LJ_DIF_YTTBAR_catr" + matrix_suffix

    intermediate_path = (
        output + "/CMS_TTBAR_8TEV_LJ_DIF_YTTBAR_intermediate"
    )
    output_path = output + "/CMS_TTBAR_8TEV_LJ_DIF_YTTBAR" + new_suffix
    if os.path.exists(input_path):
        subprocess.run(
            ["python", "./matrix_yttbar.py", "-g", input_path, "-o", intermediate_path]
        )
        subprocess.run(default + yttbar + [intermediate_path + new_suffix, output_path])
        subprocess.run(["rm", intermediate_path + new_suffix])
    else:
        gnf8.append(input_path)

    # CMS_TTBAR_8TEV_LJ_DIF_YT
    input_path = input + "/CMS_TTBAR_8TEV_LJ_DIF_YT" + matrix_suffix
    output_path = output + "/CMS_TTBAR_8TEV_LJ_DIF_YT" + new_suffix
    if os.path.exists(input_path):
        subprocess.run(default + yt + [input_path, output_path])
    else:
        gnf8.append(input_path)

    # CMS_TTBAR_8TEV_LJ_DIF_PTT
    input_path = input + "/CMS_TTBAR_8TEV_LJ_DIF_PTT" + matrix_suffix
    output_path = output + "/CMS_TTBAR_8TEV_LJ_DIF_PTT" + new_suffix
    if os.path.exists(input_path):
        subprocess.run(default + ptt + [input_path, output_path])
    else:
        gnf8.append(input_path)

    ################# 2D distributions

    # CMS_TTBAR_8TEV_2L_DIF_PTT-YT
    input_path = input + "/CMS_TTBAR_8TEV_2L_DIF_PTT-YT" + matrix_suffix
    output_path = output + "/CMS_TTBAR_8TEV_2L_DIF_PTT-YT" + new_suffix
    if os.path.exists(input_path):
        subprocess.run(
            default
            + [
                "--set-key-value",
                "x1_label",
                "top abs rapidity",
                "--set-key-value",
                "x1_label_tex",
                "$|y_t|$",
                "--set-key-value",
                "x1_unit",
                "",
            ]
            + [
                "--set-key-value",
                "x2_label",
                "top transverse momentum",
                "--set-key-value",
                "x2_label_tex",
                "$pT_t$",
                "--set-key-value",
                "x2_unit",
                "GeV",
            ]
            + [
                "--set-key-value",
                "y_label",
                "double diff x-sec",
                "--set-key-value",
                "y_label_tex",
                "$\\frac{d^2\\sigma}{d|y_t|dpT_t}$",
                "--set-key-value",
                "y_unit",
                "pb/GeV",
            ]
            + [input_path, output_path]
        )
    else:
        gnf8.append(input_path)

    # CMS_TTBAR_8TEV_2L_DIF_MTTBAR-YT
    input_path = input + "/CMS_TTBAR_8TEV_2L_DIF_MTTBAR-YT" + matrix_suffix
    output_path = output + "/CMS_TTBAR_8TEV_2L_DIF_MTTBAR-YT" + new_suffix
    if os.path.exists(input_path):
        subprocess.run(
            default
            + [
                "--set-key-value",
                "x1_label",
                "top pair mass",
                "--set-key-value",
                "x1_label_tex",
                "$m_{t\\bar{t}}$",
                "--set-key-value",
                "x1_unit",
                "GeV",
            ]
            + [
                "--set-key-value",
                "x2_label",
                "top abs rapidity",
                "--set-key-value",
                "x2_label_tex",
                "$|y_t|$",
                "--set-key-value",
                "x2_unit",
                "",
            ]
            + [
                "--set-key-value",
                "y_label",
                "double diff x-sec",
                "--set-key-value",
                "y_label_tex",
                "$\\frac{d^2\\sigma}{dm_{t\\bar{t}}d|y_t|}$",
                "--set-key-value",
                "y_unit",
                "pb/GeV",
            ]
            + [input_path, output_path]
        )
    else:
        gnf8.append(input_path)

    # CMS_TTBAR_8TEV_2L_DIF_MTTBAR-YTTBAR
    input_path = input + "/CMS_TTBAR_8TEV_2L_DIF_MTTBAR-YTTBAR" + matrix_suffix
    output_path = output + "/CMS_TTBAR_8TEV_2L_DIF_MTTBAR-YTTBAR" + new_suffix
    if os.path.exists(input_path):
        subprocess.run(
            default
            + [
                "--set-key-value",
                "x1_label",
                "top pair mass",
                "--set-key-value",
                "x1_label_tex",
                "$m_{t\\bar{t}}$",
                "--set-key-value",
                "x1_unit",
                "GeV",
            ]
            + [
                "--set-key-value",
                "x2_label",
                "top pair abs rapidity",
                "--set-key-value",
                "x2_label_tex",
                "$|y_{t\\bar{t}}|$",
                "--set-key-value",
                "x2_unit",
                "",
            ]
            + [
                "--set-key-value",
                "y_label",
                "double diff x-sec",
                "--set-key-value",
                "y_label_tex",
                "$\\frac{d^2\\sigma}{dm_{t\\bar{t}}d|y_{t\\bar{t}}|}$",
                "--set-key-value",
                "y_unit",
                "pb",
            ]
            + [input_path, output_path]
        )
    else:
        gnf8.append(input_path)

    if len(gnf8) == 0:
        print("All grids processed successfully")
    else:
        print("The following grids were not found:")
        for i in gnf8:
            print(i)
        print("Please check the input path and try again.")

    return


def process_13():
    return


if __name__ == "__main__":
    if energy == "8":
        process_8()
    elif energy == "13":
        process_13()
    else:
        print("accepted arguments are 8 or 13")
