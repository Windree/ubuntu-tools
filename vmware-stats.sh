#!/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/modules/get_disk_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_memory_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_swap_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_disks_temperature.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_git_uncommited.sh"

echo "SSD usage: $(get_disk_usage '\/$')"
echo "HDD usage: $(get_disk_usage '/media/8g/storage$')"
echo "Memory usage:" $(get_memory_usage)
echo "Swap usage:" $(get_swap_usage)
echo "Disk temperature: $(get_disks_temperature | xargs -I'{}' echo "{};" | xargs )" 
echo
echo "Uncomitted changes: $(get_git_uncommited "$HOME" | xargs)" 