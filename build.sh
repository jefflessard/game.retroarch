#!/usr/bin/env bash
set -e

RETROARCH=v1.15.0
LIBREELEC=11.0.1

build(){
  VULKAN=$(wget -O - https://github.com/LibreELEC/LibreELEC.tv/raw/${LIBREELEC}/packages/graphics/vulkan/vulkan-headers/package.mk | grep PKG_VERSION= | sed -E 's/.*="(.*)"/v\1/')
  MESA=$(wget -O - https://github.com/LibreELEC/LibreELEC.tv/raw/${LIBREELEC}/packages/graphics/mesa/package.mk | grep PKG_VERSION= | sed -E 's/.*="(.*)"/mesa-\1/')
  KODI=$(wget -O - https://github.com/LibreELEC/LibreELEC.tv/raw/${LIBREELEC}/packages/mediacenter/kodi/package.mk | grep PKG_VERSION= | sed -E 's/.*="(.*)"/\1/')

  docker build  . --build-arg VULKAN="${VULKAN}" --build-arg MESA=${MESA} --build-arg RETROARCH="${RETROARCH}" --tag game.retroarch
  docker run --rm -d --name game.retroarch game.retroarch tail -f /dev/null
  docker cp game.retroarch:/buildkit/game.retroarch.zip .
  docker cp game.retroarch:/buildkit/game.libretro.mupen64plus-nx.zip .
  docker stop game.retroarch
}

release(){
  gh release create "LE${LIBREELEC}-RA${RETROARCH}-$(date +"%Y%m%d")" ./*.zip
}

actions=$(grep -Eo '^[a-z1-9_]+\(\)' "$0" | grep -Eo '[a-z1-9_]+' | sed ':a; N; $!ba; s/\n/|/g')
cmd="${1:?No command provided. Usage: $(basename """$0""") ${actions}}"
echo "${cmd}" | grep -qE "^(${actions})$" || { echo "Unknown command ${cmd}. Usage: $(basename """$0""") ${actions}"; exit 1;}
shift 1
"$cmd" "$1" "$2"
