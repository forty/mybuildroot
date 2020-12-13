#!/bin/bash

rm -f "${BINARIES_DIR}/data.ext4"
mkfs.ext4 -r 1 -N 0 -m 5 -L "data" -O ^64bit "${BINARIES_DIR}/data.ext4" "32M"

DIRS_TO_CREATE="/etc /.etc_work /var /.var_work /home /.home_work"

for dir in ${DIRS_TO_CREATE}; do
    e2mkdir -G 0 -O 0 - P 700 "${BINARIES_DIR}/data.ext4:${dir}"
done
