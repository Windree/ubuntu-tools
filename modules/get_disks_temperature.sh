#!/usr/bin/env bash
set -Eeuo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/get_disk_temperature.sh"

function get_disks_temperature() {
    sensors -j | jq -r 'keys | . | join("\n")' | grep -P "drivetemp-" | while read key; do
        echo "$key $(get_disk_temperature "$key")"
    done
}
