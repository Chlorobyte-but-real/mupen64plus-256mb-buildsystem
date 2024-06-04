#!/bin/bash
set -e
set -o pipefail

# NOTE: relying on system libraries rather than Docker here! I'll appreciate a dockerfile in a PR (but will not bother setting it up myself lol)
git clone https://github.com/mupen64plus-ae/mupen64plus-ae.git
#   apply patches
cd mupen64plus-ae
git apply ../../PATCHES/android_256mb.patch
# NOTE: TEMPORARY; vulnerability is not patched upstream on mupen64plus-ae yet
git apply ../../PATCHES/android_vuln.patch

#   increase gradle memory for compile speed
# Peak memory usage at the time of writing this was ~3.25 GiB,
# and resulted in a ~10% improvement in build times over the default value
memsize=$(grep MemTotal /proc/meminfo | awk '{print $2}')
if (( memsize > 10000000 )); then
    # 4 GB on >10GB systems.
    sed -i 's/Xmx2048m/Xmx4096m/g' ./gradle.properties
elif (( memsize > 8000000 )); then
    # 3 GB on >=8GB systems.
    sed -i 's/Xmx2048m/Xmx3072m/g' ./gradle.properties
fi

#   build
./gradlew build
cd ..
