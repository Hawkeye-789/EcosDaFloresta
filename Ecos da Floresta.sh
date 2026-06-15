#!/bin/sh
printf '\033c\033]0;%s\a' Ecos da Floresta
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Ecos da Floresta.x86_64" "$@"
