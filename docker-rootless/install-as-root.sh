#!/usr/bin/env sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
error=0

source="$SCRIPT_DIR/files/etc/sysctl.d"
target="/etc/sysctl.d"
output=$(cd "$source" && find "./" -type f)
[ -z "$output" ] && error=1
while IFS= read -r file; do
    cp -vr "$source/$file" "$target/$file" || error=1
    chown -v root:root "$target/$file" && \
    chmod -v 0644 "$target/$file" || \
    error=1
done <<EOF
$output
EOF

[ $error -ne 0 ] && printf 'ERROR: Failed to install\n' >&2 && exit 1
echo "OK"
exit 0
