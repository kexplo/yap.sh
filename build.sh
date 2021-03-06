#!/usr/bin/env bash

set -euo pipefail

readonly yapsh_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p "$yapsh_dir/gh-pages"

secho () {
  local color="$1"
  local msg="$2"
  if [[ -z "$TERM" ]]; then
    echo "$msg"
  else
    echo -e "$(tput setaf "${color}")${msg}$(tput sgr0)"
  fi
}

info () {
  local msg="$1"
  # Print an information log.
  secho 6 "$msg"
}

gh-cp () {
  local filename="$1"
  cp "$filename" "$yapsh_dir/gh-pages/"
}

gh-idx-append () {
  local source="$1"
  cat "$source" >> "$yapsh_dir/gh-pages/index.html"
}

gh-idx-append-line () {
  local line="$1"
  echo "$line" >> "$yapsh_dir/gh-pages/index.html"
}

gh-cp "CNAME"
gh-cp "index.html"
gh-idx-append "yap.sh"

for recipe in $yapsh_dir/recipes/*; do
  if [[ -f "$recipe" ]]; then
    _basename="$(basename "$recipe")"
    gh-idx-append-line "echo '================================================================================'"
    gh-idx-append-line "info 'Running $_basename...'"
    gh-idx-append "$recipe"
    gh-idx-append-line "echo '================================================================================'"
    gh-idx-append-line "echo ''"
    info "$(basename "$recipe") added"
  fi
done

chmod +x "$yapsh_dir/gh-pages/index.html"
cp "$yapsh_dir/web.html" "$yapsh_dir/gh-pages"
cp -rf "$yapsh_dir/w" "$yapsh_dir/gh-pages"
