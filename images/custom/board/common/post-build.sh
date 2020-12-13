#!/bin/bash

set -u
set -e

if [ -e "${TARGET_DIR}/etc/inittab" ]; then
    # keep rootfs in RO mode
    sed -i '/::sysinit:\/bin\/mount -o remount,rw \//d' "${TARGET_DIR}/etc/inittab"
    # alias data partition to /dev/data
    grep -q '::sysinit:/bin/ln -sf $(/sbin/findfs LABEL=data) /dev/data' "${TARGET_DIR}/etc/inittab" || \
        sed -i '/::sysinit:\/bin\/mount -a/i\
::sysinit:/bin/ln -sf $(/sbin/findfs LABEL=data) /dev/data
' "${TARGET_DIR}/etc/inittab"
fi

# Create data directory
mkdir -p "${TARGET_DIR}/data"

if [ -e "${TARGET_DIR}/etc/fstab" ]; then
    grep -qE '^/dev/data' "${TARGET_DIR}/etc/fstab" || \
        echo '/dev/data	/data	ext4	rw	0	2' >> "${TARGET_DIR}/etc/fstab"
    grep -qE '^overlay	/etc' "${TARGET_DIR}/etc/fstab" || \
        echo 'overlay	/etc	overlay	lowerdir=/etc,upperdir=/data/etc,workdir=/data/.etc_work	0	0' >> "${TARGET_DIR}/etc/fstab"
    grep -qE '^overlay	/var' "${TARGET_DIR}/etc/fstab" || \
        echo 'overlay	/var	overlay	lowerdir=/var,upperdir=/data/var,workdir=/data/.var_work	0	0' >> "${TARGET_DIR}/etc/fstab"
    grep -qE '^overlay	/root' "${TARGET_DIR}/etc/fstab" || \
        echo 'overlay	/root	overlay	lowerdir=/root,upperdir=/data/home,workdir=/data/.home_work	0	0' >> "${TARGET_DIR}/etc/fstab"
fi
