#!/bin/bash

set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
target_user="${1:-cs1660-user}"

export DEBIAN_FRONTEND=noninteractive
export TZ=America/New_York

# set up default locale
export LANG=en_US.UTF-8

apt-get update &&\
  yes | unminimize

# install GCC-related packages
apt-get update && apt-get -y install\
 build-essential\
 binutils-doc\
 cpp-doc\
 gcc-doc\
 g++\
 g++-multilib\
 gdb\
 gdbserver\
 gdb-doc\
 glibc-doc\
 libblas-dev\
 liblapack-dev\
 liblapack-doc\
 libstdc++-11-doc\
 make\
 make-doc

# Do main setup
$SCRIPT_DIR/container-setup-common $target_user

# Install golang
bash -c "mkdir /usr/local/go && wget -O - https://go.dev/dl/go1.21.6.linux-amd64.tar.gz | tar -xvz -C /usr/local"

# create binary reporting version of dockerfile
(echo '#\!/bin/sh'; echo 'echo 1') > /usr/bin/cs1660-docker-version
chmod ugo+rx,u+w,go-w /usr/bin/cs1660-docker-version
