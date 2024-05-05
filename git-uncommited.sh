#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_git_uncommited.sh"

(
    for i in "$@"; do
        get_git_uncommited "$i"
    done
) | sort
