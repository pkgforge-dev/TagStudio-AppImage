#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
  ripgrep \
  libva \
  libvdpau \
  pipewire \
  qt6-base \
  unrar

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini

echo "Downloading TagStudio..."
echo "---------------------------------------------------------------"
TAG=$(curl -sI https://github.com/TagStudioDev/TagStudio/releases/latest | grep -i '^location:' | awk -F'/' '{print $NF}' | tr -d '\r')
VERSION="${TAG#v}"
echo "$VERSION" >~/version

TARBALL="tagstudio_${TAG}_linux_${ARCH}.tar.gz"
URL="https://github.com/TagStudioDev/TagStudio/releases/download/${TAG}/${TARBALL}"

mkdir -p ./AppDir/bin
wget --retry-connrefused --tries=30 "$URL" -O "./$TARBALL"
tar -xzf "./$TARBALL" -C ./AppDir/bin
rm -f "./$TARBALL"
