#!/bin/env bash

set -Eeuo pipefail

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
	if which crontab >/dev/null; then
		echo "Backup crontab"
		crontab -l >"$tmp/crontab.txt"
	fi
	local list="$(get_list | sort)"
	echo "Backup files:"
	echo "$list"
	echo -n "$list" | backup "$tmp"

	local status=$(git -C "$tmp" status -s)
	if [[ -z "$status" ]]; then
		exit
	fi
	echo "$status"
	git -C "$tmp" add . >/dev/null
	git -C "$tmp" commit -m "$(date)" >/dev/null
	git -C "$tmp" push
}

function get_list() {
	find "${paths[@]}" -type f -exec realpath {} \; | filter_attribute "$attribute"
}

function filter_attribute() {
	while read -r file; do
		if getfattr --absolute-names --name "$1" "$file" 2>/dev/null >/dev/null; then
			echo "$file"
		fi
	done
}

function backup() {
	while read -r path; do
		local target="$1/$path"
		mkdir -p "$(dirname "$target")"
		cp -ar "$path" "$target"
	done
}

function validate() {
	local error=0
	if ! which git >/dev/null; then
		echo "git not installed."
		error=1
	fi
	if ! which getfattr >/dev/null || ! which setfattr >/dev/null; then
		echo "attr not installed."
		error=1
	fi
	if [ $error -ne 0 ]; then
		echo "Exiting"
		exit $error
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
