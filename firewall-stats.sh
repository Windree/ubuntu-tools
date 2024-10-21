#!/usr/bin/env bash
set -Eeuo pipefail

function main() {
    local ports=$(ufw status | tail -n +5 | grep -vF 'ALLOW FWD' | grep -oP '\d+(?=/(tcp|udp))' | sort -n | uniq)
    while read port; do
        echo "$port: $(find /app -name '.env' | xargs grep -lP "=$port" | xargs)"
    done <<< "$ports"
}

main
