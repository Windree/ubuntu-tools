#!/usr/bin/env bash
set -Eeuxo pipefail

temp=$(mktemp --directory)
files=$(mktemp)

function main() {
    local local_path=$2
    local samba_share=$3

    mount -t cifs \
        -o credentials=$4,rw,noexec,cache=strict,uid=0,noforceuid,gid=0,noforcegid,iocharset=utf8,nocase,echo_interval=5 \
        "$samba_share" "$temp" || exit 1
    local source_path=
    local rsync_source=
    local rsync_target=
    local arguments=()
    case "$1" in
    "samba-to-local")
        rsync_source=$temp/
        rsync_target=$local_path/
        ;;
    "local-to-samba")
        rsync_source=$local_path/
        rsync_target=$temp/
        ;;
    *)
        echo 1>&2 "samba-to-local or local-to-samba supported only"
        exit 1
        ;;
    esac
    if [ -v 5 ]; then
        arguments+=("--checksum")
        arguments+=("--files-from="$files"")
        (cd "$rsync_source" && find "." -type f -not -path './$RECYCLE.BIN' -and -not -path './System Volume Information' 2>/dev/null) | shuf | head -n $5 >"$files" || exit 1
    fi
    rsync --recursive --times --partial --out-format="%n" --delete-during --backup --exclude='$RECYCLE.BIN' --exclude='System Volume Information' --exclude=".recycle/" --backup-dir=".recycle/$(date +%Y%m%d-%H%M%S)/" "${arguments[@]}" "$rsync_source" "$rsync_target" 2>/dev/null || exit 1
}

function cleanup() {
    while mountpoint -q "$temp"; do
        umount "$temp"
    done
    rm "$files"
    rm -d "$temp"
}

trap cleanup exit

main "$@"
