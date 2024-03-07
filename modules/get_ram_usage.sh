#!/usr/bin/env bash
set -Eeuo pipefail

function get_ram_usage() {
    local total=$(free -b | grep -P "^Mem:" | awk '{print $2}')
    local free=$(free -b | grep -P "^Mem:" | awk '{print $7}')
    echo "$(perl -e "printf('%.0f%',($total-$free)/$total*100)") $(perl -e "printf('%.0f',$total/1024/1024)")"
}
