#!/usr/bin/env bash
set -Eeuo pipefail
declare prefix="verify-backup"
declare original="$(mktemp -d)"
declare original_md5="$(mktemp)"
declare restored="$(mktemp -d)"
declare restored_md5="$(mktemp)"

function main() {
    local archive="$1"
    local source="$2"
    local run_before="$source/.backup/before"
    local run_after="$source/.backup/after"
    [ -x "$run_before" ] && "$run_before"
    echo "Creating new source's snapshot"
    rsync -a "$source/" "$original/"
    echo "Creating new backup"
    /app/dar-tools/app.sh create "$archive" "$source" --slice 200M
    
    [ -x "$run_after" ] && "$run_after"
    echo "Extracting from new backup"
    /app/dar-tools/app.sh extract "$archive" "$restored"
    
    (
        cd "$original"
        echo "Calculating source's snapshot md5 files hash"
        /app/ubuntu-tools/create-md5sum.sh . "$original_md5"
    )
    (
        cd "$restored"
        echo "Calculating extracted md5 files hash"
        /app/ubuntu-tools/create-md5sum.sh . "$restored_md5"
    )
    echo "Comparing source's snapshot files -> extracted files.."
    diff "$original_md5" "$restored_md5" && echo "OK: '$source' and '$archive' are equal" || exit 1
}

function cleanup() {
    rm -rf  "$original" "$restored"
}

trap cleanup exit

if [ $# -ne 2 ]; then
    echo "Usage: $0 [backup directory] [data directory]"
    exit 1
fi

main $@
