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


build_root=$BUILD_ROOT_LOL
# PATH=$ANDROID_NDK_ROOT_LOL/build/tools/:$PATH

mkdir -p $build_root
ndk_mirror=$build_root/mirror
cp -vr $ANDROID_NDK_ROOT_LOL/ $ndk_mirror
chmod u+w -R $ndk_mirror

args="--api 23 --stl=libc++"

archs=(arm64)

for arch in ${archs[@]}; do
    bin=$ndk_mirror/build/tools/make_standalone_toolchain.py

    out=$build_root/tool/$arch
    echo "installing toolchain for ${arch} into $out"

    if [ ! -d "$out" ]; then
        echo "installing $arch"
        echo $bin $args --arch $arch --install-dir $out
        $bin $args --arch $arch --install-dir $out
    fi

done
