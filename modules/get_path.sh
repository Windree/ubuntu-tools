#!/usr/bin/env bash
set -Eeuo pipefail

function get_path() {
    dirname "$(realpath $1)"
}
