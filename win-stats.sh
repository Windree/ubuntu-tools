#!/bin/env bash

set -Eeuo pipefail

function exec(){
    ssh -i $HOME/.ssh/id_ed25519 Administrator@10.22.0.12 -s powershell | ansi2txt | grep -vP 'PS .+'
}

function show_disk_stats(){
    cat << 'EOF' | exec
    Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID,@{'Name' = 'FreeSpace (GB)'; Expression= { [int]($_.FreeSpace / 1GB) }};
EOF
}

function show_ram_stats(){
    cat << 'EOF' | exec
    Get-CIMInstance Win32_OperatingSystem | Select FreePhysicalMemory | Select-Object -Property @{'Name' = 'Free Memory'; Expression= { [int]($_.FreePhysicalMemory / 1024) }};
EOF
}
show_ram_stats
show_disk_stats