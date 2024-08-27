#!/bin/bash

set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
target_user="${1:-cs1270-user}"

export DEBIAN_FRONTEND=noninteractive
export TZ=America/New_York

# set up default locale
export LANG=en_US.UTF-8

apt update &&
  yes | unminimize

# install GCC-related packages
# removed gdb (c debugger), libblas-dev and liblapack-dev (linear algebra routines), and doc packages
# potential to remove: g++-multilib (for cross-compiling to different architectures)
apt -y install build-essential g++ g++-multilib make

# Do main setup
$SCRIPT_DIR/container-setup-common $target_user

# Install golang
bash -c "mkdir /usr/local/go && wget -O - https://go.dev/dl/go1.23.0.linux-amd64.tar.gz | tar -xvz -C /usr/local"

# create binary reporting version of dockerfile
(
  echo '#\!/bin/sh'
  echo 'echo 1'
) >/usr/bin/cs1270-docker-version
chmod ugo+rx,u+w,go-w /usr/bin/cs1270-docker-version
