#!/usr/bin/env sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
error=0

uid=$(id -u)
gid=$(id -g)
home=$(cd ~ && pwd)

source="$SCRIPT_DIR/files/home/dravorn"
target="$home"
cp -vr "$source/." "$target/" || error=1
output=$(cd "$source" && find "./" -type f)
[ -z "$output" ] && error=1
while IFS= read -r file; do
   chown -v "$uid:$gid" "$target/$file" && \
   chmod -v 0644 "$target/$file" || \
   error=1
done <<EOF
$output
EOF

[ $error -ne 0 ] && printf 'ERROR: Failed to install\n' >&2 && exit 1
echo "OK"
exit 0
