#!/usr/bin/env bash
set -Eeuo pipefail

function exec_btrfs_scrub() {
    btrfs scrub start -c 19 -Bd "$1"
}
