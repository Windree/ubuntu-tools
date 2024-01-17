#!/bin/env bash
set -Eeuo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_filesystem_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/modules/get_ram_usage.sh"

function get_ext4() {
    df --output=target --type ext4 | sed 1d
}

function get_ram() {
    echo "RAM usage:" $(get_ram_usage)
}

function get_storage() {
    get_ext4 | while read partition; do
        echo "Storage usage $partition: $(get_filesystem_usage "$partition")"
    done
}

function get_cpu_temperature() {
    echo "CPU Temperature: $(sensors | grep -A3 -P '^cpu' | grep -P '^temp1:' | awk '{print $2}')"
}

function get_hdd_temperature() {
    find /dev/sd* -type b | grep -vP '\d$' | while read disk; do
        echo "HDD temperature ($disk): $(smartctl --all "$disk" | grep -F "Temperature_Celsius" | awk '{print "+"$10".0°C"}')"
    done
}

for arg in "$@"; do
    case $arg in
    "cpu_temperature") get_cpu_temperature ;;
    "hdd_temperature") get_hdd_temperature ;;
    "ram") get_ram ;;
    "storage") get_storage ;;
    esac
done
