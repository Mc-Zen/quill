
import os
import subprocess
from typing import Tuple


with open("tests/config.txt") as file:
    typst_path = file.read().strip(" \n")
# os.system("cd " + typst_path)
# print(typst_path)


def run_typst(filename: str) -> Tuple[str, int]:
    path = os.path.join(typst_path, "typst")
    typ_path = os.path.join(typst_path, filename)
    process = subprocess.Popen([path, "compile", typ_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (stdout, stderr) = process.communicate()
    exit_code = process.wait()
    color_codes = ["\\x1b[36m", "\\x1b[1m", "\\x1b[0m", "\\x1b[38;5;9m", "\\x1b[31m"]
    stderr = str(stderr).replace("\\n", "\n").replace(R"\xe2\x94\x82", "|").replace(R"\xe2\x94\x8c", "┌").replace(R"\xe2\x94\x80", "─")
    for code in color_codes:
        stderr = stderr.replace(code, "")
    # print(f"code: {exit_code}")
    # print(err)
    return stderr, exit_code
    # os.system(os.path.join(typst_path, "typst compile ") + )

