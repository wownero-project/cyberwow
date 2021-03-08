# Copyright (c) 2019-2020, The Wownero Project
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

let
  nixpkgs = import <nixpkgs> {}

; android-studio-deps = with nixpkgs;
  [
    coreutils
    findutils
    file
    git
    gn
    gnused
    gnutar
    glib
    gzip
    pciutils
    unzip
    which
    xkeyboard_config
  ]

; vendorCmake = nixpkgs.libsForQt5.callPackage ./deps/cmake {}

; ndk-r21d =
    let
      version = "r21d"
    ; in
    nixpkgs.fetchzip
    {
      url = "https://dl.google.com/android/repository/android-ndk-${version}-linux-x86_64.zip"
    ; sha256 = "0jc3pd0022bgld7k3sy9sc1n0ahfbcx194gil2ka3p8s4nyf0fsg"
    ; }

; ndk-r23 =
    let
      version = "r23-beta1"
    ; in
    nixpkgs.fetchzip
    {
      url = "https://dl.google.com/android/repository/android-ndk-${version}-linux-x86_64.zip"
    ; sha256 = "1cj0gph1a49a67ysqqvjmkiff4ppjc2409ry09ji8dsvfy930s06"
    ; }

; openssl-source =
    let
      name = "openssl"
    ; version = "1.1.1g"
    ; in
    nixpkgs.fetchurl
    {
      url = "https://www.openssl.org/source/${name}-${version}.tar.gz"
    ; sha256 = "0ikdcc038i7jk8h7asq5xcn8b1xc2rrbc88yfm4hqbz3y5s4gc6x"
    ; }

; boost-source =
    let
      name = "boost"
    ; version = "1_71_0"
    ; dot_version = "1.71.0"
    ; in
    nixpkgs.fetchurl
      {
        url =
        "https://dl.bintray.com/boostorg/release/${dot_version}/source/${name}_${version}.tar.bz2"
      # ; sha256 = "1js9zpij58l60kx46s3lxdp5207igppjnhqigwhbpdvd04gb6gcm"
      ; sha256 = "1vi40mcair6xgm9k8rsavyhcia3ia28q8k0blknwgy4b3sh8sfnp"
      ; }

; sodium-source =
    let
      name = "libsodium"
    ; version = "1.0.18"
    ; in
    nixpkgs.fetchurl
    {
      url = "https://github.com/jedisct1/${name}/archive/${version}.tar.gz"
    ; sha256 = "1x6lll81z4ah732zwpw481qfbzg7yml0nwdgbnd5388jnz3274ym"
    ; }


; lolnero-rev = "v0.8.3.8"
; lolnero-sha256 = "0jx4almv534f7sna7hinjzxv5rvyx9hyqynsjc9h7z6bwrpy70kf"

; lolnero-source =
    nixpkgs.fetchgit
    {
      url = "https://gitlab.com/fuwa/lolnero.git"
    ; rev = lolnero-rev
    ; sha256 = lolnero-sha256
    ; fetchSubmodules = false
    ; }

; in

with nixpkgs;

(buildFHSUserEnv {
  name = "lolnode-env"
; targetPkgs = pkgs: (with pkgs;
  [
    bash
    git
    curl
    unzip
    libGLU
    which

    zsh
    # jdk8 for sdkmanager
    jdk8

    # jdk for android dev
    # jdk

    # dart_dev
    gnumake
    gcc
    entr
    # androidenv.androidPkgs_9_0.platform-tools


    zlib
    ncurses
    # gcc
    libtool
    autoconf
    automake
    gnum4
    pkgconfig
    vendorCmake
    ccache

    python2
  ]
  ++ android-studio-deps
  )

; multiPkgs = pkgs: (with pkgs;
  [
  ])


; profile = ''
    export ANDROID_HOME=~/SDK/Android/Sdk

    PATH=~/local/sdk/flutter/stable/bin:$PATH
    PATH=~/SDK/Android/android-studio/bin:$PATH
    PATH=~/SDK/Android/Sdk/tools/bin:$PATH

    export ANDROID_NDK_VERSION=r21d
    export ANDROID_NDK_ROOT=${ndk-r21d}
    export NDK=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64
    PATH=$NDK/bin:$PATH

    export SRC_OPENSSL=${openssl-source}
    export SRC_BOOST=${boost-source}
    export SRC_SODIUM=${sodium-source}
    export SRC_RAPIDJSON_DIR=${nixpkgs.rapidjson.src}
    export SRC_LOLNERO_DIR=${lolnero-source}
    export VERSIONTAG_LOLNERO=${lolnero-rev}

    export PATH_NCURSES=${nixpkgs.ncurses5}
    export PATH

    export _JAVA_AWT_WM_NONREPARENTING=1
    export DART_VM_OPTIONS=--root-certs-file=/etc/ssl/certs/ca-certificates.crt

    export ANDROID_NDK_VERSION_LOL=r23
    export ANDROID_NDK_ROOT_LOL=${ndk-r23}

    export ZSH_INIT=${nixpkgs.oh-my-zsh}/share/oh-my-zsh/oh-my-zsh.sh
    exec zsh
  ''

; }).env
