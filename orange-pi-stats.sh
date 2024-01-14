#!/bin/env bash
set -Eeuo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_local_partitions.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_filesystem_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_memory_usage.sh"

disk=0
ram=0
temperature=0

for arg in "$@"; do
    case $arg in
    "disk") disk=1 ;;
    "ram") ram=1 ;;
    "temperature") temperature=1 ;;
    esac
done

function get_ext4() {
    df --output=target --type ext4 | tail -n +2
}

if [ $disk -eq 1 ]; then
    get_ext4 | while read partition; do
        echo "Disk usage $partition: $(get_filesystem_usage "$partition")"
    done
fi

if [ $ram -eq 1 ]; then
    echo "Memory usage:" $(get_memory_usage)
fi

if [ $temperature -eq 1 ]; then
    echo "Temperature:"
    echo "CPU: $(sensors | grep -A3 -P '^cpu' | grep -P '^temp1:' | awk '{print $2}')"
    echo "HDD: $(smartctl --all /dev/sda | grep -F "Temperature_Celsius" | awk '{print "+"$10".0°C"}')"
fi
