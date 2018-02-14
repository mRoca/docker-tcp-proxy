#!/usr/bin/env sh

echo "relay TCP/IP connections on :${TARGET_PORT} to ${TARGET}:${TARGET_PORT}"
socat TCP-LISTEN:${TARGET_PORT},fork,reuseaddr TCP:${TARGET}:${TARGET_PORT}
