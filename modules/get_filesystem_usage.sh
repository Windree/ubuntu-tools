#!/bin/env bash
set -Eeuo pipefail

function get_filesystem_usage(){
    local output=$(df --block-size=1 "$1" | tail -n +2)
    local used=$(echo "$output" | awk '{print $3}')
    local available=$(echo "$output" | awk '{print $4}')
    local usage=$(echo "$output" | awk '{print $5}')
    local space=$(((used+available)/1024/1024))
    echo "$usage $space"
}
