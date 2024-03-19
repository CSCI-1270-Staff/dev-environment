#!/bin/bash

set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
target_user="${1:-cs1270-user}"

# set up default locale
export LANG=en_US.UTF-8

# set up libraries
apt-get -y install\
 libreadline-dev\
 locales\
 wamerican\
 libssl-dev

# set up default locale
locale-gen en_US.UTF-8
export LANG=en_US.UTF-8

# install programs used for system exploration
apt-get -y install\
 blktrace\
 linux-tools-generic\
 strace\
 tcpdump\
 htop\
 file\
 xxd

# install interactive programs (emacs, vim, nano, man, sudo, etc.)
apt-get -y install\
 bc\
 curl\
 dc\
 git\
 git-doc\
 man\
 micro\
 nano\
 psmisc\
 sudo\
 wget\
 screen\
 tmux\
 emacs-nox\
 vim

# install programs used for networking
apt-get -y install\
 dnsutils\
 inetutils-ping\
 iproute2\
 net-tools\
 netcat\
 nmap\
 telnet\
 time\
 pv\
 traceroute\
 tshark

apt-get install -y python3 \
	python3-pip \
	python3-dev \
	python3-setuptools \
	python3-venv


# TODO: check this works on arm64
# Install conda so we can install jupyterlab and pandas (for SQL assignment).
# We always download and install the latest miniconda3,
# and then downgrade python to specific version.
# We could instead download a specific miniconda3 version,
# but that would require baking in the URLs for
# different Miniconda installer versions into the Dockerfile.
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"; \
    wget --quiet $MINICONDA_URL -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh && \
    /opt/conda/bin/conda clean --all
# PIP_TARGET="/opt/conda/lib/python${FROM_PYTHON_VERSION}/site-packages"
conda install -c conda-forge jupyterlab
conda install -c conda-forge gxx_linux-64==11.1.0 pandas

# remove unneeded .deb files
rm -r /var/lib/apt/lists/*

# Set up the container user
if [[ $target_user == "cs1270-user" ]]; then
    useradd -m -s /bin/bash $target_user
else
    # If using the host's user, don't create one--podman will do this
    # automatically.  However, the default shell will be wrong, so set
    # a profile rule to update this
    chmod +x /etc/profile.d/20-fix-default-shell.sh # Copied in Podmanfile
fi

# set up passwordless sudo for user cs1270-user
echo "cs1270-user ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/cs1270-init

rm -f /root/.bash_logout
