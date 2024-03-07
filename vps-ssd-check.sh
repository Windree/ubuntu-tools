#!/usr/bin/env bash
set -Eeuo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/modules/exec_btrfs_scrub.sh"

function get_partitions() {
    echo /
    echo /media/app
}

get_partitions | while read partition; do
    echo "Checking partition '$partition'"
    exec_btrfs_scrub "$partition"
    echo
done
