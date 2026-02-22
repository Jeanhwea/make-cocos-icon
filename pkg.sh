#!/usr/bin/env bash
set -eux

APP_PKG=make-cocos-icon
GIT_TAG=$(git describe --tags --always --dirty="+dev")
OUT_DIR=output
OS_ARCH=$(uname -m)
OS_NAME=$(uname -s)
ZIP_DIR=${OUT_DIR}
ZIP_IMG=${APP_PKG}-${OS_NAME}-${OS_ARCH}-${GIT_TAG}.zip

# Clean old builds
rm -rf ${OUT_DIR}

# Build application
# source .venv/bin/activate
uv run python -m nuitka main.py

cd ${OUT_DIR}
zip ${ZIP_IMG} ${APP_PKG}
