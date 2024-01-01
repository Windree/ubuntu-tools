#!/bin/env bash
set -Eeuo pipefail

tmp=$(mktemp -d)

function install(){
    if ! which xmllint > /dev/null; then
        sudo apt install -y libxml2-utils
    fi
    if ! which 7z > /dev/null; then
        sudo apt install -y p7zip-full
    fi
}

function main(){
    echo "Check for phpMyAdmin update..."
    local content=$(get_content "https://www.phpmyadmin.net/downloads/")

    local content_version=$(get_version "$content")
    local local_version=$(get_local_version "$1")
    

    echo "Remote/Local versions: $content_version/$local_version"

    local url=$(get_url "$content")
    [ "$content_version" != "$local_version" ] || {
        echo "No updates found"
        return
    }

    echo "Downloading update..." 
    local file=$(download "$url")

    echo "Extracting update..."
    local extracted=$(extract "$file")

    echo "Deploying update..." 
    deploy "$extracted" "$1"

    echo "Completted."
}

function download(){
    local file=$(mktemp -u)
    curl --silent "$1" --output "$file"
    echo "$file"
}

function get_content(){
    curl --silent "$1"
}

function get_url(){
    echo "$1" | xmllint --html --xpath 'string(//a[contains(@href, "zip")][1]/@href)' - 2>/dev/null
}

function get_version(){
    echo "$1" | xmllint --html --xpath 'string(//a[contains(@href, "zip")][1]/@href)' - 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -n 1
}

function get_local_version(){
    [ -f "$1/README" ] || {
        echo 0 
        return
    }
    cat "$1/README" | grep -oP '\d+\.\d+\.\d+' | head -n 1
}

function extract(){
    local dir="$tmp/phpmyadmin"
    mkdir "$dir"
    7z x -y -o"$dir" "$1" > /dev/null
    find "$dir" -maxdepth 1 -mindepth 1
}

function deploy(){
    rsync --recursive --delete-during --exclude '.htaccess' --exclude 'config.inc.php' --exclude 'robots.txt' "$1/" "$2/"
}

function cleanup(){
    echo "Cleaning up..." 
    rm -rf "$tmp"
}

trap 'cleanup' EXIT

install
main "$1"