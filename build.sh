#!/bin/bash
set -e

LIBREELEC=11.0.1
VULKAN=$(wget -O - https://github.com/LibreELEC/LibreELEC.tv/raw/${LIBREELEC}/packages/graphics/vulkan/vulkan-headers/package.mk | grep PKG_VERSION= | sed -E 's/.*="(.*)"/v\1/')
MESA=$(wget -O - https://github.com/LibreELEC/LibreELEC.tv/raw/${LIBREELEC}/packages/graphics/mesa/package.mk | grep PKG_VERSION= | sed -E 's/.*="(.*)"/mesa-\1/')
KODI=$(wget -O - https://github.com/LibreELEC/LibreELEC.tv/raw/${LIBREELEC}/packages/mediacenter/kodi/package.mk | grep PKG_VERSION= | sed -E 's/.*="(.*)"/\1/')

docker build  . --build-arg VULKAN="${VULKAN}" --build-arg MESA=${MESA} --tag game.retroarch
docker run --rm -d --name game.retroarch game.retroarch tail -f /dev/null
docker cp game.retroarch:/buildkit/game.retroarch.zip .
docker cp game.retroarch:/buildkit/game.libretro.mupen64plus-nx.zip .
docker stop game.retroarch
