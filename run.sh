#!/bin/bash

set -e

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "Two arguments required: (absolute path to mount in container), (ip or network to accept connections from)"
echo $1 | grep -E -q '^\/.+$' || die "Absoulute path required as first argument"


mkdir -p $1
chmod a+rwx $1


docker build -t file_transfer_server .

docker run -it --rm --name=fts \
    --cap-add=NET_ADMIN \
    -p 12322:22 \
    -v $1:/home/user:rw \
    -e ALLOWED_SRC=$2 \
    file_transfer_server
