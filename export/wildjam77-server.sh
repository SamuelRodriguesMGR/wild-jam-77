#!/bin/sh
echo -ne '\033c\033]0;GodotTemplate\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/wildjam77-server.x86_64" "$@"
