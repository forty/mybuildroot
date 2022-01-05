#!/bin/bash

set -e

BOARD_CFG="$2"
BOARD_DIR="$(dirname "${BOARD_CFG}")"
source "${BOARD_CFG}"

################################################################################
# Build data.ext4
################################################################################

rm -f "${BINARIES_DIR}/data.ext4"
mkfs.ext4 -r 1 -N 0 -m 5 -L "data" -O ^64bit "${BINARIES_DIR}/data.ext4" "32M"

DIRS_TO_CREATE="/etc /.etc_work /var /.var_work /home /.home_work"

which e2mkdir
for dir in ${DIRS_TO_CREATE}; do
    e2mkdir -G 0 -O 0 - P 700 "${BINARIES_DIR}/data.ext4:${dir}"
done

################################################################################
# Build image
################################################################################

GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

# Pass an empty rootpath. genimage makes a full copy of the given rootpath to
# ${GENIMAGE_TMP}/root so passing TARGET_DIR would be a waste of time and disk
# space. We don't rely on genimage to build the rootfs image, just to insert a
# pre-built one in the disk image.

trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
ROOTPATH_TMP="$(mktemp -d)"

rm -rf "${GENIMAGE_TMP}"

genimage \
	--rootpath "${ROOTPATH_TMP}"   \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
