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

DEFAULT_ANDROID_NDK_VERSION=r21d
ANDROID_NDK_VERSION="${ANDROID_NDK_VERSION:-${DEFAULT_ANDROID_NDK_VERSION}}"

DEFAULT_ANDROID_NDK_ROOT=~/SDK/Android/ndk-archive/android-ndk-${ANDROID_NDK_VERSION}
ANDROID_NDK_ROOT="${ANDROID_NDK_ROOT:-${DEFAULT_ANDROID_NDK_ROOT}}"
export ANDROID_NDK_ROOT=`realpath $ANDROID_NDK_ROOT`

BUILD_PATH=../lolnode-build

DEFAULT_BUILD_ROOT=${BUILD_PATH}/$ANDROID_NDK_VERSION
BUILD_ROOT="${BUILD_ROOT:-${DEFAULT_BUILD_ROOT}}"
export BUILD_ROOT=`realpath $BUILD_ROOT`

BUILD_ROOT_SRC=${BUILD_ROOT}/src

DEFAULT_NPROC=$(nproc)
NPROC="${NPROC:-${DEFAULT_NPROC}}"

export NPROC


#  can only be built with ndk-r17c

DEFAULT_ANDROID_NDK_VERSION_LOL=r23
ANDROID_NDK_VERSION_LOL="${ANDROID_NDK_VERSION_LOL:-${DEFAULT_ANDROID_NDK_VERSION_LOL}}"

DEFAULT_ANDROID_NDK_ROOT_LOL=$ANDROID_NDK_ROOT/../$ANDROID_NDK_VERSION_LOL
ANDROID_NDK_ROOT_LOL="${ANDROID_NDK_ROOT_LOL:-${DEFAULT_ANDROID_NDK_ROOT_LOL}}"
export ANDROID_NDK_ROOT_LOL=`realpath $ANDROID_NDK_ROOT_LOL`

DEFAULT_BUILD_ROOT_LOL=${BUILD_PATH}/$ANDROID_NDK_VERSION_LOL
BUILD_ROOT_LOL="${BUILD_ROOT_LOL:-${DEFAULT_BUILD_ROOT_LOL}}"
export BUILD_ROOT_LOL=`realpath $BUILD_ROOT_LOL`



