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

name=wownero
version=v0.9.3.3
githash=e2d2b9a447502e22467af9df20e0732b3dd4ac4c
out=wownero

chmod u+w -f -R $out || true

rm -rf $out

if [ ! -z $SRC_WOWNERO_DIR ]; then
    echo "using pre-fetched $name"
    rsync -av --no-perms --no-owner --no-group --delete $SRC_WOWNERO_DIR/* $out
    chmod u+w -R $out/external
    cd $name
else
    git clone --depth 1 https://git.wownero.com/wownero/wownero.git -b $version
    cd $name
    test `git rev-parse HEAD` = $githash || exit 1
fi


if [ ! -z $SRC_MINIUPNP_DIR ]; then
    echo "using pre-fetched miniupnpc"
    rsync -av --no-perms --no-owner --no-group --delete $SRC_MINIUPNP_DIR/* external/miniupnp
else
    git submodule update --init external/miniupnp
fi

if [ ! -z $SRC_RAPIDJSON_DIR ]; then
    echo "using pre-fetched rapidjson"
    rsync -av --no-perms --no-owner --no-group --delete $SRC_RAPIDJSON_DIR/* external/rapidjson
else
    git submodule update --init external/rapidjson
fi

if [ ! -z $SRC_RANDOMWOW ]; then
    echo "using pre-fetched RandomWOW"
    tar xzf $SRC_RANDOMWOW -C external/RandomWOW --strip-components=1
else
    git submodule update --init external/RandomWOW
fi

if [ ! -z $SRC_UNBOUND_DIR ]; then
    echo "using pre-fetched unbound"
    rsync -av --no-perms --no-owner --no-group --delete $SRC_UNBOUND_DIR/* external/unbound
else
    git submodule update --init external/unbound
fi
