#!/usr/bin/env bash

mrlog section-start --name="needs check"
needs check
result=$?
mrlog section-end --name="needs check" --result=${result}
if [[ $result -ne 0 ]] ; then
    echo "needs check failed" >&2
    exit 1
fi

log-dependencies.sh

mrlog section-start --name="tile install"
<<<<<<< HEAD
install-tile.sh "/tile/${TILE_NAME}" "/tile-config/${TILE_CONFIG}"
result=$?
mrlog section-end --name="tile install" --result=$result
if [[ $result -ne 0 ]] ; then
    echo "install-tile failed" >&2
    exit 1
fi

mrlog section-start --name="tile uninstall"
uninstall-tile.sh "/tile/${TILE_NAME}"
result=$?
mrlog section-end --name="tile uninstall" --result=$result
if [[ $result -ne 0 ]] ; then
    echo "uninstall-tile failed" >&2
    exit 1
fi
=======
install-tile.sh "/tile/${TILE_NAME}" "/tile-config/${TILE_CONFIG}" "${USE_SELECTIVE_DEPLOY:-false}"
mrlog section-end --name="tile install" --result=$?

mrlog section-start --name="tile uninstall"
uninstall-tile.sh "/tile/${TILE_NAME}" "${USE_SELECTIVE_DEPLOY:-false}"
mrlog section-end --name="tile uninstall" --result=$?
>>>>>>> Pass along a flag to use selective deployment
