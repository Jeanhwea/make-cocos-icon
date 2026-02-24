#!/usr/bin/env bash
set -eux

GIT_TAG=$(git describe --tags --always --dirty="+dev")
OUT_DIR=output
DST_DIR=dist
OS_NAME=$(uname -s)
OS_ARCH=$(uname -m)
DMG_DIR=${OUT_DIR}/dmg

APP_PKG=make-cocos-icon
APP_ENT=main.py

_dist_app() {
    APP_PKG=$1
    APP_ENT=$2
    DMG_VOL=${APP_PKG}-${OS_NAME}-${OS_ARCH}-${GIT_TAG}
    DMG_IMG=${OUT_DIR}/${APP_PKG}-${OS_NAME}-${OS_ARCH}-${GIT_TAG}.dmg


    # Build application
    # source .venv/bin/activate
    uv run python -m nuitka --assume-yes-for-downloads ${APP_ENT} --output-dir=${OUT_DIR}

    # Create dmg volume
    if [ "${OS_NAME}" = "Darwin" ]; then
        mkdir -p ${DMG_DIR}
        mv ${OUT_DIR}/${APP_PKG} ${DMG_DIR}
        hdiutil create -volname ${DMG_VOL} -srcfolder ${DMG_DIR} -ov -format UDZO ${DMG_IMG}
        mkdir -p ${DST_DIR}
        mv ${DMG_IMG} ${DST_DIR}
    fi

    rm -rf ${OUT_DIR}
}

# Clean old builds
rm -rf ${OUT_DIR}

_dist_app make-cocos-icon main.py
