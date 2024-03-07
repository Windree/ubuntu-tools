#!/usr/bin/env bash
set -Eeuo pipefail

function get_public_address() {
    curl -s -$1 https://api64.ipify.org
}
