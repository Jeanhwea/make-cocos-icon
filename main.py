# -*- coding: utf-8 -*-
# Compilation mode, support OS-specific options
#    nuitka-project: --standalone
#    nuitka-project: --onefile
#    nuitka-project: --output-filename=make-cocos-icon
#    nuitka-project: --output-dir=output
# nuitka-project-if: {OS} in ("Linux"):
#    nuitka-project: --static-libpython=no
#

import argparse

from src.app import gen_cocos_icon_files
from src.consts import (
    APP_DESCRIPTION,
    APP_NAME,
    APP_VERSION,
)


def main():
    parser = argparse.ArgumentParser(description=APP_DESCRIPTION)
    parser.add_argument("source", help="Source image path (1024x1024 recommended)")
    parser.add_argument("-v", "--version", action="version", version=APP_VERSION)

    args = parser.parse_args()
    gen_cocos_icon_files(args.source)


if __name__ == "__main__":
    main()
