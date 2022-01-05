#!/bin/bash

set -u
set -e

BOARD_CFG="$2"
BOARD_DIR="$(dirname "${BOARD_CFG}")"
source "${BOARD_CFG}"

################################################################################
# Create temporary key to sign the rauc bundle
################################################################################

if [ -n "${RAUC_KEY_FILE+x}" ]; then
    ln -sf "$RAUC_KEY_FILE" "${BINARIES_DIR}/key.pem"
    ln -sf "$RAUC_CERT_FILE" "${BINARIES_DIR}/cert.pem"
    ln -sf "$RAUC_CA_FILE" "${BINARIES_DIR}/ca.pem"
elif [ ! -e "${BINARIES_DIR}/key.pem" ]; then
	echo "/!\\ Generating temporary key for the build /!\\"
	openssl req \
		-x509 \
		-newkey rsa:4096 \
		-nodes \
		-keyout "${BINARIES_DIR}/key.pem" \
		-out "${BINARIES_DIR}/cert.pem" \
		-subj "/O=Forty/CN=temp-build-cert"
	ln -sf "${BINARIES_DIR}/cert.pem" "${BINARIES_DIR}/ca.pem"
fi

cp "${BINARIES_DIR}/ca.pem" "${TARGET_DIR}/etc/rauc/ca.pem"
cp "${BOARD_DIR}/rauc.conf" "${TARGET_DIR}/etc/rauc/system.conf"
cp "${BOARD_DIR}/fw_env.config" "${TARGET_DIR}/etc/fw_env.config"
