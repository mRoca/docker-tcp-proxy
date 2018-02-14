#!/usr/bin/env sh

scriptdir="$(dirname "$0")"

if [ -z "${TARGET}" ]; then
    echo "You must set the TARGET variable"
    exit 1
fi

if [ -z "${TARGET_PORT}" ]; then
    echo "You must set the TARGET_PORT variable"
    exit 1
fi

echo "Target : ${TARGET}, Port: ${TARGET_PORT}"

nc -w 3 -vz ${TARGET} ${TARGET_PORT}
if [ $? -ne 0 ]; then
    echo -e "\nUnable to access the ${TARGET}:${TARGET_PORT} port"
    exit 2
fi

if [ "${PROXY_ENGINE}" = "iptables" ]; then
    ${scriptdir}/iptables.sh
else
    ${scriptdir}/socat.sh
fi
