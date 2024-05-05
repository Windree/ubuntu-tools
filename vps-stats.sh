#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_btrfs_subvolume_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_filesystem_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_ram_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_swap_usage.sh"

function get_btrfs_volumes() {
    echo "/"
    echo "/app"
    echo "/data"
}

function get_ext4() {
    df --output=target --type ext4 | sed 1d
}

get_btrfs_volumes | while read partition; do
    echo "BTRFS usage $partition: $(get_btrfs_subvolume_usage "$partition")"
done

get_ext4 | while read partition; do
    echo "EXT4 usage $partition: $(get_filesystem_usage "$partition")"
done

echo "RAM usage:" $(get_ram_usage)
echo "Swap usage:" $(get_swap_usage)
