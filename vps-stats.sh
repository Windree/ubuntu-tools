#!/bin/env bash
set -Eeuo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_local_partitions.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_partition_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_btrfs_subvolume_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_filesystem_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_memory_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_swap_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_git_uncommited.sh"


function get_btrfs_subvolumes(){
    true
}

function get_ext4(){
    df --output=target --type ext4 | tail -n +2
}

get_btrfs_subvolumes | while read partition; do
    echo "BTRFS usage $partition: $(get_btrfs_subvolume_usage "$partition")"
done

get_ext4 | while read partition; do
    echo "Disk usage $partition: $(get_filesystem_usage "$partition")"
done

echo "Memory usage:" $(get_memory_usage)
echo "Swap usage:" $(get_swap_usage)

echo "Docker all/restarting: $(docker ps --format "{{.Names}}" | wc -l)/$(docker ps --format "{{.Names}}" --filter status=restarting | wc -l)"
echo
docker ps --format "{{.Status}}\t{{.Names}}s"
echo
echo "ufw status:" 
ufw status numbered
echo
echo "Uncomitted changes: $(get_git_uncommited "$HOME" | xargs) $(get_git_uncommited "/media/app" | xargs)" 

