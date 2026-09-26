#!/usr/bin/env bash
docker images --format '{{.Repository}}:{{.Tag}}' | while read -r image; do
    # Replace slashes and colons with underscores to create safe filenames
    filename=$(echo "$image" | tr '/:' '__')
    echo "Exporting $image to ${filename}.tar..."
    docker save -o "${filename}.tar" "$image"
done