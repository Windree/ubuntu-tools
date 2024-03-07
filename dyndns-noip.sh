#!/usr/bin/env bash
set -Eeuo pipefail
source "${BASH_SOURCE[0]}.env"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_public_address.sh"

function main() {
    local ipv4=$(get_public_address "4")
    local ipv6=$(get_public_address "6")
    echo Updating ipv4
    update_address "d4.ddns.net" "$ipv4"
    echo Updating ipv6
    update_address "d4.ddns.net" "$ipv6"
}

function update_address() {
    curl "http://$user:$key@dynupdate.no-ip.com/nic/update?hostname=$1&myip=$2"
}

main
