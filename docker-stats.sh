#!/usr/bin/env bash
set -Eeuo pipefail

echo "All:        $(docker ps --format "{{.Names}}" | wc -l)"
echo "Restarting: $(docker ps --format "{{.Names}}" --filter status=restarting | wc -l)"
echo
docker ps --format "{{.Names}}\t{{.Status}}" | sort | sed -E "s/\t/\n\t/"
