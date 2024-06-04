#!/bin/bash

# The build times are pretty funny.
# On my system (Arch Linux, i7-4770s, DDR3 4x4GB 2000MT/s),
# - a build with Docker cache takes 17 minutes
# - a clean build (no Docker cache) takes 2 hours and 10 minutes!
# Good luck

set -e
set -o pipefail

rm -rf ./build
cp -r ./template ./build
cd ./build

function build() {
    system=$1

    cd ./$system
    chmod +x ./build.sh
    image_id="mupen_build/${system}" container_id="mupen_build_${system}_container" ./build.sh
    cd ..
}

build linux_x86_64
build win_x86_64
build win_x86
build android

# TODO: Nintendo Switch build is not included yet,
# it's painful & I don't consider the vulnerability a major issue there
# consider: what could an attacker do on a switch console?



# Extract artifacts
mkdir -p ./out
mkdir -p ./out/x86
mkdir -p ./out/x86_64
# linux x64
cp ./linux_x86_64/developer/mupen64plus-core/projects/unix/libmupen64plus.so.2.0.0 ./out/x86_64
cp ./linux_x86_64/developer/mupen64plus-libretro-nx/mupen64plus_next_libretro.so ./out/x86_64
# windows x64
cp ./win_x86_64/developer/mupen64plus-core/projects/unix/mupen64plus.dll ./out/x86_64
cp ./win_x86_64/developer/mupen64plus-libretro-nx/mupen64plus_next_libretro.dll ./out/x86_64
# windows x86
cp ./win_x86/developer/mupen64plus-core/projects/unix/mupen64plus.dll ./out/x86
cp ./win_x86/developer/mupen64plus-libretro-nx/mupen64plus_next_libretro.dll ./out/x86
# android
cp ./android/mupen64plus-ae/app/build/outputs/apk/release/Mupen64PlusAE-release.apk ./out
