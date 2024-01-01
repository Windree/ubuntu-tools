#!/bin/env bash
set -Eeuo pipefail
source "${BASH_SOURCE[0]}.env"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_public_address.sh"

function main() {
    local ipv4=$(get_public_address "4")
    local ipv6=$(get_public_address "6")
    echo Updating ipv4
    update_address 4 "$key_ipv4" "$ipv4"
    echo
    echo Updating ipv6
    update_address 6 "$key_ipv6" "$ipv6"
    echo
}

function update_address() {
    curl "https://ipv$1.cloudns.net/api/dynamicURL/?q=$2&ip=$3"
}

main
