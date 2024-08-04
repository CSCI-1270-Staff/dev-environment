#!/bin/bash

set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
target_user="${1:-cs1270-user}"

# set up default locale
export LANG=en_US.UTF-8

# set up libraries
apt -y install libreadline-dev locales wamerican libssl-dev

# set up default locale
locale-gen en_US.UTF-8
export LANG=en_US.UTF-8

# install programs used for system exploration
apt -y install blktrace linux-tools-generic strace tcpdump htop file xxd

# install interactive programs (emacs, vim, nano, man, sudo, etc.)
apt -y install bc curl dc git git-doc man micro nano psmisc sudo wget screen tmux vim
# emacs-nox\

# install programs used for networking
apt -y install net-tools dnsutils inetutils-ping iproute2 netcat nmap telnet time pv traceroute tshark

# install python dependencies (needed for sql assignment)
apt -y install python3-pip
pip install jupyterlab pandas

# install Task
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin


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
echo "cs1270-user ALL=(ALL:ALL) NOPASSWD: ALL" >/etc/sudoers.d/cs1270-init

rm -f /root/.bash_logout
