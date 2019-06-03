#!/usr/bin/env bash

# TODO: This should be replaced with a standardized dependency check utility
if ! ops-manifest --version ; then
    echo "ops-manifest is not present"
    exit 1
fi

if [[ -z "${TILE_PATH}" ]] ; then
    echo "TILE_PATH is not defined"
    exit 1
fi

if [[ -z "${CONFIG_FILE_PATH}" ]] ; then
    echo "CONFIG_FILE_PATH is not defined"
    exit 1
fi
