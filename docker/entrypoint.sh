#!/bin/sh
set -e

version_file=/etc/image-version

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
        set -- "$@"
fi
echo "***************************************************************************************"
if [ -e "${version_file}" ]; then
    echo "Starting container:  $(cat ${version_file})"
fi
echo "This container's internal IP:  $(hostname --ip-address)"
if [ -e ${version_file} ]; then
    echo "This container's internal hostname:  $(cat ${version_file} | cut -d' ' -f 1)"
fi

echo "***************************************************************************************"

exec "$@"
