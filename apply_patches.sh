#!/bin/sh
##!/usr/bin/env bash

PORTS_ROOT=/usr/ports
PORTS_PATCH_ROOT=$(dirname $(readlink -f "$0"))
#PORTS_PATCH_ROOT=/var/lib/shares/Poudriere/freebsd-ports_arm-patches

echo $0

find "${PORTS_PATCH_ROOT}" -maxdepth 4 -mindepth 4 -name ports-patch* | {
	while read PATCH; do
		PORT=$(echo "${PATCH}"|awk 'BEGIN{FS="/"}{print $(NF-3)"/"$(NF-2)}')
		PATCH_NAME=$(echo "${PATCH}"|awk 'BEGIN{FS="/"}{print $NF}')
		echo "Applying patch to ports tree: ${PORT}: ${PATCH_NAME}"
		echo "  cd \"${PORTS_ROOT}/${PORT}\""
		echo "  cat \"${PATCH}\" | patch"
	done
}

find "${PORTS_PATCH_ROOT}" -maxdepth 4 -mindepth 4 -name patch* | {
	while read PATCH; do
		PORT=$(echo "${PATCH}"|awk 'BEGIN{FS="/"}{print $(NF-3)"/"$(NF-2)}')
		PATCH_NAME=$(echo "${PATCH}"|awk 'BEGIN{FS="/"}{print $NF}')
		echo "Copying patch to ports tree: ${PORT}: ${PATCH_NAME}"
		echo "  cp \"${PATCH}\" \"${PORTS_ROOT}/${PORT}/files/"
	done
}
