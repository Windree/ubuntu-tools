#!/bin/env bash
set -Eeuo pipefail
source "${BASH_SOURCE[0]}.env"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_public_address.sh"

function main() {
    local ipv4=$(get_public_address "4")
    local ipv6=$(get_public_address "6")
    echo Updating ipv4
    update_address "$key_ipv4" "$ipv4"
    echo Updating ipv6
    update_address "$key_ipv6" "$ipv6"
}

function update_address() {
    curl "https://freedns.afraid.org/dynamic/update.php?$1&address=$2"
}

main
