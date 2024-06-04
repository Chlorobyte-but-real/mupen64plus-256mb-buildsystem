#!/bin/bash
set -e
set -o pipefail

docker rm -v -f $container_id
docker build -t=$image_id .
docker run --name $container_id -idt $image_id
#   build raw mupen core
docker exec $container_id git clone https://github.com/mupen64plus/mupen64plus-core.git
docker cp ../PATCHES/core_256mb.patch $container_id:/developer/mupen64plus-core/256mb.patch
docker exec $container_id bash -c 'cd mupen64plus-core && git apply 256mb.patch'
docker exec $container_id bash -c 'cd mupen64plus-core/projects/unix && CROSS_COMPILE=x86_64-w64-mingw32.static- HOST_CPU=x86_64 UNAME=MINGW make all -j$(nproc)'
#   build libretro core
docker exec $container_id git clone https://github.com/libretro/mupen64plus-libretro-nx
docker cp ../PATCHES/ra_256mb.patch $container_id:/developer/mupen64plus-libretro-nx/256mb.patch
docker exec $container_id bash -c 'cd mupen64plus-libretro-nx && git apply 256mb.patch'
    # NOTE: TEMPORARY; vulnerability is not patched upstream on libretro yet
    docker cp ../PATCHES/ra_vulnpatch.patch $container_id:/developer/mupen64plus-libretro-nx/vulnpatch.patch
    docker exec $container_id bash -c 'cd mupen64plus-libretro-nx && git apply vulnpatch.patch'
docker exec $container_id bash -c 'cd mupen64plus-libretro-nx && make -j$(nproc)'
#   end build windows
docker cp $container_id:/developer/ ./
