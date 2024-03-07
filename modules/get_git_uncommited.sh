#!/usr/bin/env bash
set -Eeuo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/get_path.sh"

function get_git_uncommited() {
    find "$1" -type d -name .git | while read git; do
        local repo=$(get_path "$git")
        if ! git_status "$repo" "$git"; then
            echo $repo
        fi
    done
}

function git_status() {
    if [[ -z $(git --work-tree="$1" --git-dir="$2" status -s) ]]; then
        return 0
    fi
    return 1
}
