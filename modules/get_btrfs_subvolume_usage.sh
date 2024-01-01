#!/bin/env bash
set -Eeuo pipefail

function get_btrfs_subvolume_usage(){
    local used=$(btrfs filesystem usage "$1" -b | grep -P "^\s*Used:" | sed -r "s/^\s*Used://" | awk '{print $1}')
    local total=$(btrfs filesystem usage "$1" -b | grep -P "^\s*Device size:" | sed -r "s/^\s*Device size://" | awk '{print $1}')
    local usage=$(perl -e "printf('%.0f%',($used/$total*100))")
    local space=$(perl -e "printf('%.0f',($total/1024/1024))")
    echo "$usage $space"
}
