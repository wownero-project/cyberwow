# Copyright (c) 2019, The Lolnero Project
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


.PHONY: toolchain clean

clean:
	-rm -f ./lolnode/android/app/src/main/jniLibs/arm64-v8a/*.so
	cd lolnode && \
  flutter clean

watch:
	find lolnode/lib/ -name '*.dart' | \
	entr kill -USR1 `cat /tmp/flutter.pid`

watch-build:
	find lolnode/lib/ -name '*.dart' | \
	entr $(MAKE) build-debug

run:
	cd lolnode && \
	flutter run --debug --pid-file /tmp/flutter.pid

run-release:
	cd lolnode && \
	flutter run --release --pid-file /tmp/flutter.pid

build:
	cd lolnode && \
	flutter build apk --target-platform android-arm64

build-bundle:
	cd lolnode && \
	flutter build appbundle --target-platform android-arm64

build-debug:
	cd lolnode && \
	flutter build appbundle --debug --target-platform android-arm64

install: build
	cd lolnode && \
  flutter install

# build lolnero android binary

script := etc/scripts/build-external-libs

lol: clean-external-libs collect-lolnero build

clean-external-libs:
	$(script)/clean.sh

toolchain:
	$(script)/toolchain/import.sh

boost:
	$(script)/boost/fetch.sh
	$(script)/boost/build.sh

openssl: toolchain
	$(script)/openssl/fetch.sh
	$(script)/openssl/build.sh

sodium: toolchain
	$(script)/sodium/fetch.sh
	$(script)/sodium/build.sh

toolchain-lol:
	$(script)/toolchain-lol/import.sh
	$(script)/toolchain-lol/patch.sh

lolnero: openssl boost sodium toolchain-lol
	$(script)/lolnero/fetch.sh
	$(script)/lolnero/build.sh

lolnero-raw:
	$(script)/lolnero/fetch.sh
	$(script)/lolnero/build.sh

collect-lolnero: lolnero
	$(script)/collect.sh

collect-lolnero-raw: lolnero-raw
	$(script)/collect.sh

# etc

remove-exif:
	exiftool -all= `find fastlane/ -name '*.jp*g' -o -name '*.png'`

