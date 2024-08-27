#!/bin/bash

set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

export DEBIAN_FRONTEND=noninteractive
export TZ=America/New_York

apt update &&
  yes | unminimize

# include multiarch support
apt -y install binfmt-support &&
  dpkg --add-architecture amd64 &&
  apt update &&
  apt -y upgrade

# install GCC-related packages
apt -y install build-essential g++ make

# install GCC-related packages for amd64 (might not be necessary for CSCI 1270)
apt -y install g++-11-x86-64-linux-gnu gdb-multiarch libc6:amd64 libstdc++6:amd64 libasan5:amd64 libtsan0:amd64 libubsan1:amd64 libreadline-dev:amd64

# might not be necessary for CSCI 1270
for i in addr2line c++filt cpp-11 g++-11 gcc-11 gcov-11 gcov-dump-11 gcov-tool-11 size strings; do
  ln -s /usr/bin/x86_64-linux-gnu-$i /usr/x86_64-linux-gnu/bin/$i
done &&
  ln -s /usr/bin/x86_64-linux-gnu-cpp-11 /usr/x86_64-linux-gnu/bin/cpp &&
  ln -s /usr/bin/x86_64-linux-gnu-g++-11 /usr/x86_64-linux-gnu/bin/c++ &&
  ln -s /usr/bin/x86_64-linux-gnu-g++-11 /usr/x86_64-linux-gnu/bin/g++ &&
  ln -s /usr/bin/x86_64-linux-gnu-gcc-11 /usr/x86_64-linux-gnu/bin/gcc &&
  ln -s /usr/bin/x86_64-linux-gnu-gcc-11 /usr/x86_64-linux-gnu/bin/cc &&
  ln -s /usr/bin/gdb-multiarch /usr/x86_64-linux-gnu/bin/gdb

# Do main setup
$SCRIPT_DIR/container-setup-common

# Install golang
bash -c "mkdir /usr/local/go && wget -O - https://go.dev/dl/go1.23.0.linux-arm64.tar.gz | tar -xvz -C /usr/local"

# create binary reporting version of dockerfile
(
  echo '#\!/bin/sh'
  echo 'echo 1'
) >/usr/bin/cs1270-docker-version
chmod ugo+rx,u+w,go-w /usr/bin/cs1270-docker-version
