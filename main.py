# -*- coding: utf-8 -*-
# Compilation mode, support OS-specific options
#    nuitka-project: --standalone
#    nuitka-project: --onefile
#    nuitka-project: --output-filename=make-cocos-icon
#    nuitka-project: --output-dir=output
# nuitka-project-if: {OS} in ("Linux"):
#    nuitka-project: --static-libpython=no
#

from src.app import gen_cocos_icon_files
from src.__version__ import __title__

import argparse


def main():
    parser = argparse.ArgumentParser(description=__title__)
    parser.add_argument("source", help="Source image path (1024x1024 recommended)")

    args = parser.parse_args()
    gen_cocos_icon_files(args.source)


if __name__ == "__main__":
    main()
