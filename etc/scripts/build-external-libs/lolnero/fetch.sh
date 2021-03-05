#!/usr/bin/env bash

# Copyright (c) 2019-2020, The Wownero Project
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

cd $BUILD_ROOT_SRC

name=lolnero
version=v0.5.0.0
# version=dev-v0.8
githash=1271a7e3a97c0d81816b401627aefb6c6697d0b3
out=lolnero

chmod u+w -f -R $out || true

rm -rf $out

if [ ! -z $SRC_LOLNERO_DIR ]; then
    echo "using pre-fetched $name"
    rsync -av --no-perms --no-owner --no-group --delete $SRC_LOLNERO_DIR/* $out
    chmod u+w -R $out/vendor
    cd $name
else
    git clone --depth 1 https://gitlab.com/fuwa/lolnero.git -b $version
    cd $name
    test `git rev-parse HEAD` = $githash || exit 1
fi


if [ ! -z $SRC_RAPIDJSON_DIR ]; then
    echo "using pre-fetched rapidjson"
    rsync -av --no-perms --no-owner --no-group --delete $SRC_RAPIDJSON_DIR/* vendor/rapidjson
else
    git submodule update --init vendor/rapidjson
fi
