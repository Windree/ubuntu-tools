#!/bin/env bash
set -Eeuo pipefail

function get_partition_usage(){
    local used=$(df | grep -F "$1" | head -n 1 | awk '{print $5}')
    local total=$(df -m | grep -F "$1" | head -n 1 | awk '{print $2}')
    echo "$used $total"
}
