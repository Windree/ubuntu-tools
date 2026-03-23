#!/usr/bin/env bash
set -Eeuo pipefail

declare tmp="$(mktemp)"

function cleanup() {
    rm -f $tmp
}

if [ $# -ne 2 ]; then
    echo "Usage: $0 [source directory] [md5 result file]"
    exit 1
fi

trap cleanup exit

find "$1"  -type f -exec md5sum "{}" + | awk '{first = $1; $1 = ""; print substr($0, 2), first}' > "$tmp"
cat "$tmp" | sort > "$2"