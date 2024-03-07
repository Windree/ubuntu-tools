#!/usr/bin/env bash
set -Eeuo pipefail

function get_swap_usage() {
    local total=$(free -b | grep -P "^Swap:" | awk '{print $2}')
    local free=$(free -b | grep -P "^Swap:" | awk '{print $4}')
    if [ "$total" != "0" ]; then
        echo "$(perl -e "printf('%.0f%',($total-$free)/$total*100)") $(perl -e "printf('%.0f',$total/1024/1024)")"
    fi
}
