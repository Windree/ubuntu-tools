#!/bin/env bash

set -Eeuxo pipefail

tmp=$(mktemp -d)

git=$1
shift
attribute=$1
shift
declare -a paths=("$@")

function main() {
	git clone "$git" "$tmp" >/dev/null 2>/dev/null
	echo "Cleanup"
	find "$tmp" -type f -not -path '*/.git/*' -exec rm {} \;
	echo "Backup crontab"
	crontab -l >"$tmp/crontab.txt"
	local list="$(get_list)"
	echo "Backup files:"
	echo "$list"
	echo "$list" | backup "$tmp"

	local status=$(git -C "$tmp" status -s)
	if [[ -z "$status" ]]; then
		exit
	fi
	git -C "$tmp" status -s
	git -C "$tmp" add . >/dev/null
	git -C "$tmp" commit -m "$(date)" >/dev/null
	git -C "$tmp" push
}

function get_list() {
	find "${paths[@]}" -type f -print0 | xargs -0 -n 1 xattr | grep -oP "^.+(?=: $attribute$)" | xargs realpath
}

function backup() {
	while read -r path; do
		local target="$1/$path"
		mkdir -p "$(dirname "$target")"
		cp -ar "$path" "$target"
	done
}

function validate() {
	if ! which git >/dev/null; then
		echo "git not installed"
		return 1
	fi
	if ! which xattr >/dev/null; then
		echo "xattr not installed"
		return 1
	fi
}

function cleanup() {
	if [ -d "$tmp" ] && ! rm -rf "$tmp"; then
		echo "Can't delete temp directory"
		exit 1
	fi
}

trap cleanup EXIT

validate
main
