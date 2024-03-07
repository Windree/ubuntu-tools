#!/usr/bin/env bash
set -Eeuo pipefail

docker system prune -f && docker images -q | xargs docker rmi
