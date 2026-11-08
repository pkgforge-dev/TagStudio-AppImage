#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/TagStudioDev/TagStudio/main/src/tagstudio/resources/icon.png
export DESKTOP=https://raw.githubusercontent.com/TagStudioDev/TagStudio/main/src/tagstudio/resources/tagstudio.desktop
export DEPLOY_QT=1
# the app only needs the host GPU drivers, do not bundle mesa/vulkan
export USE_HOST_DRIVERS_EXPERIMENTAL=1

# Deploy dependencies
quick-sharun \
  ./AppDir/bin/tagstudio \
  /usr/bin/rg \
  /usr/bin/ffmpeg \
  /usr/bin/ffprobe

# Ensure PyInstaller finds _internal in shared/bin where quick-sharun moves the binary
ln -sf ../../bin/_internal ./AppDir/shared/bin/_internal

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app
quick-sharun --simple-test ./dist/*.AppImage
