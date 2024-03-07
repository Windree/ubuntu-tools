#!/usr/bin/env bash
set -Eeuo pipefail

run_port=/run/remote-tunnel-lock-port
ssh_user=tunnel
ssh_lock_port=$([ -f "$run_port" ] && cat "$run_port" || echo -n $(($RANDOM + 30000)) | tee "$run_port")

declare -a ipvs="$1"
declare -a hosts="$2"
declare -a ports="$3"
declare -a tunnels="$4"

function create_tunnel() {
    ssh -$1 -C -o PasswordAuthentication=no -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -N -L $ssh_lock_port:localhost:22 -R $4:localhost:22 -p "$3" "$ssh_user@$2"
}

function connect() {
    echo "Creating a tunnel:"
    for host in ${hosts[@]}; do
        for port in ${ports[@]}; do
            for tunnel in ${tunnels[@]}; do
                for proto in ${ipvs[@]}; do
                    echo -n "  Connecting $ssh_user@$host:$port via ipv$proto and tunnel $tunnel: "
                    create_tunnel "$proto" "$host" "$port" "$tunnel" || true
                    echo "  FAILED"
                done
            done
        done
    done
}

function available() {
    echo -n "Checking for existing tunnel: "
    if [ -n "$(lsof -t -iTCP:$ssh_lock_port -cLISTEN)" ]; then
        echo "FOUND"
        return 1
    fi
    echo "NOT FOUND"
}

if ! which ssh >/dev/null; then
    echo "openssh-client is not installed. Exiting"
    exit 1
fi
if ! which lsof >/dev/null; then
    echo "lsof is not installed. Exiting"
    exit 1
fi

if available; then
    connect
fi
echo "Exiting"
