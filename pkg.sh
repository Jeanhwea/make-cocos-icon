#!/usr/bin/env bash
set -eux

APP_PKG=make-cocos-icon
GIT_TAG=$(git describe --tags --always --dirty="+dev")
OUT_DIR=output
DST_DIR=dist
OS_ARCH=$(uname -m)
OS_NAME=$(uname -s)

DMG_DIR=${OUT_DIR}/dmg
DMG_VOL=${APP_PKG}-${OS_NAME}-${OS_ARCH}-${GIT_TAG}
DMG_IMG=${OUT_DIR}/${APP_PKG}-${OS_NAME}-${OS_ARCH}-${GIT_TAG}.dmg

# Clean old builds
rm -rf ${OUT_DIR}

# Build application
# source .venv/bin/activate
uv run python -m nuitka main.py

mv ${OUT_DIR}/${APP_PKG} ${DMG_DIR}
hdiutil create -volname ${DMG_VOL} -srcfolder ${DMG_DIR} -ov -format UDZO ${DMG_IMG}
mkdir -p ${DST_DIR}
mv ${DMG_IMG} ${DST_DIR}

rm -rf ${OUT_DIR}
