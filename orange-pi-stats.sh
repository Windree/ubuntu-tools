#!/bin/env bash
set -Eeuo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_local_partitions.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_partition_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_filesystem_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_memory_usage.sh"

function get_ext4() {
    df --output=target --type ext4 | tail -n +2
}

get_ext4 | while read partition; do
    echo "Disk usage $partition: $(get_filesystem_usage "$partition")"
done

echo "Memory usage:" $(get_memory_usage)

echo "Temperature:"
echo "CPU: $(sensors | grep -A3 -P '^cpu' | grep -P '^temp1:' | awk '{print $2}')"
echo "HDD: $(smartctl --all /dev/sda | grep -F "Temperature_Celsius" | awk '{print "+"$10".0°C"}')"
