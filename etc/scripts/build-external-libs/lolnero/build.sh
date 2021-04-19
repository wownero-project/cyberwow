#!/usr/bin/env bash

# Copyright (c) 2019, The Wownero Project
# Copyright (c) 2014-2019, The Monero Project
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this list of
#    conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice, this list
#    of conditions and the following disclaimer in the documentation and/or other
#    materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors may be
#    used to endorse or promote products derived from this software without specific
#    prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
# THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
# THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

set -e

source etc/scripts/build-external-libs/env.sh

build_root=$BUILD_ROOT
src_root=$BUILD_ROOT_SRC

build_root_lol=$BUILD_ROOT_LOL

name=lolnero

cd $src_root/${name}

archs=(arm64)
for arch in ${archs[@]}; do
    extra_cmake_flags=""
    case ${arch} in
        "arm")
            target_host=arm-linux-androideabi
            ;;
        "arm64")
            target_host=aarch64-linux-android
            ;;
        "x86_64")
            target_host=x86_64-linux-android
            ;;
        *)
            exit 16
            ;;
    esac

    ndk_root=${BUILD_ROOT_LOL}/mirror
    echo "ndk_root: $ndk_root"

    PREFIX=$build_root/build/$arch
    echo "building for ${arch}"

    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PREFIX/dlib
    ccdir=$ndk_root/toolchains/llvm/prebuilt/linux-x86_64/bin/host/bin

    mkdir -p build/release
    pushd .
    cd build/release
    (
        CC="$ccdir/aarch64-linux-android-clang" \
          CXX="$ccdir/aarch64-linux-android-clang++" \
          cmake \
          -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
          -DCMAKE_C_COMPILER_LAUNCHER=ccache \
          -G Ninja \
          -DOPENSSL_INCLUDE_DIR=$PREFIX/include/openssl \
          -DOPENSSL_CRYPTO_LIBRARY=$PREFIX/lib/libcrypto.a \
          -DOPENSSL_SSL_LIBRARY=$PREFIX/lib/libssl.a \
          -DBoost_INCLUDE_DIR=$PREFIX/include \
          -DBoost_LIBRARY_DIR=$PREFIX/lib \
          -DSODIUM_LIBRARY=$PREFIX/lib/libsodium.a \
          -D CMAKE_BUILD_TYPE=release \
          -D ANDROID=true \
          -D CMAKE_SYSTEM_NAME="Android" \
          -D ANDROID_ABI="arm64-v8a" \
          -D USE_READLINE=OFF \
          -DCMAKE_TOOLCHAIN_FILE=${ndk_root}/build/cmake/android.toolchain.cmake \
          -DANDROID_TOOLCHAIN=clang \
          -DANDROID_NATIVE_API_LEVEL=28 \
          ../.. && ninja -j${NPROC} lolnerod
    )
    popd

done

exit 0
