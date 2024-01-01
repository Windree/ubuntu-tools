#!/bin/bash
set -Eeuo pipefail

connect_timeout=5
wifi_delay=10

declare -A config="$1"
declare -a ipvs="$2"
declare -a urls="$3"

function wifi() {
    echo "WiFi:"

    echo "Cleaning up connections"

    if ! nmcli --get-values NAME con | xargs -I{} nmcli con delete "{}"; then
        echo "Faled to reset"
        return 1
    fi

    if ! nmcli radio wifi on; then
        echo "Faled to enable"
        return 1
    fi

    echo "Wating $wifi_delay"
    sleep $wifi_delay

    for name in ${!config[@]}; do
        echo -n "Looking for $name: "
        if nmcli --get-values SSID device wifi list | grep -F "$name" >/dev/null; then
            echo -n "FOUND "
            if nmcli dev wifi con "$name" password "${config[${name}]}" >/dev/null; then
                echo "CONNECTED"
                return 0
            else
                echo "FAILED"
                return 1
            fi
        else
            echo "NOT FOUND "
        fi
    done
}

function validate_connection() {
    echo "Checking connection: "
    if ! which curl >/dev/null; then
        echo "  curl is not installed. Skipping"
        return 0
    fi

    if [ "${#urls[@]}" -eq 0 ]; then
        echo "  No hosts to check. Skipping"
        return 0
    fi

    for host in "${urls[@]}"; do
        for proto in "${ipvs[@]}"; do
            echo -n "  Check $host via ipv$proto: "
            if curl -$proto --connect-timeout $connect_timeout --head "$host" 2>/dev/null >/dev/null; then
                echo "OK"
                return 0
            else
                echo "FAILED"
            fi
        done
    done

    return 1
}

if ! which nmcli >/dev/null; then
    echo "nmcli is not installed. Skipping"
    exit 1
fi

if ! validate_connection; then
    if ! wifi; then
        reboot
    fi
fi
