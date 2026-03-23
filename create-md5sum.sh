#!/usr/bin/env bash
set -Eeuo pipefail

if [ $# -ne 3 ]; then
    echo "Usage: $0 [source directory] [md5 scan result] [sorted md5 scan result]"
    exit 1
fi


find "$1"  -type f -exec md5sum "{}" + | awk '{first = $1; $1 = ""; print substr($0, 2), first}' > "$2"
cat "$2" | sort > "$3"