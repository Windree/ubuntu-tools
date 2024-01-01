#!/bin/env bash
set -Eeuo pipefail

function get_disk_temperature(){
    sensors -j | jq -r '.["'$1'"].temp1.temp1_input'
}
