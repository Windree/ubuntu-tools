#!/bin/env bash
set -Eeuo pipefail

function get_local_partitions(){
    df | awk '{ print $1 }' | grep -P '/dev/sd\w' | sort | uniq
}
