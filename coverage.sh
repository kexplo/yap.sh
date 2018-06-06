#!/usr/bin/env bash

set -euo pipefail

readonly yapsh_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

recipe_count=0
ubuntu_16_count=0
ubuntu_18_count=0
osx_count=0

no_ubuntu_16_recipes=()
no_ubuntu_18_recipes=()
no_osx_recipes=()

is_osx () {
  [[ "$(uname)" == "Darwin" ]]
}

increase_all_count () {
  ubuntu_16_count=$((ubuntu_16_count+1))
  ubuntu_18_count=$((ubuntu_18_count+1))
  osx_count=$((osx_count+1))
}

check_skip_os () {
  local os="$1"
  local recipe_path="$2"
  local mangled_os
  if is_osx; then
    mangled_os=$(echo "$os" | sed -E 's/\ /_/; s/\./_/')
  else
    mangled_os=$(echo "$os" | sed -r 's/\s/_/; s/\./_/')
  fi
  grep -q "# skip os: $os" "$recipe_path" || grep -q "is_${mangled_os}" "$recipe_path"
}

function print_no_recipes() {
  local -a arr=("$@")
  for item in "${arr[@]}"; do
    echo "    - ✘ $item"
  done
}

function run() {
  for recipe in $yapsh_dir/recipes/*; do
    if [[ -f "$recipe" ]]; then
      _basename="$(basename "$recipe")"
      if check_skip_os "all" "$recipe"; then
        recipe_count=$((recipe_count+1))
        increase_all_count
        continue
      fi
      if check_skip_os "ubuntu 16.04" "$recipe"; then
        ubuntu_16_count=$((ubuntu_16_count+1))
      else
        no_ubuntu_16_recipes+=("$_basename")
      fi
      if check_skip_os "ubuntu 18.04" "$recipe"; then
        ubuntu_18_count=$((ubuntu_18_count+1))
      else
        no_ubuntu_18_recipes+=("$_basename")
      fi
      if check_skip_os "osx" "$recipe"; then
        osx_count=$((osx_count+1))
      else
        no_osx_recipes+=("$_basename")
      fi
      recipe_count=$((recipe_count+1))
    fi
  done

  echo "OS Coverages:"
  echo "  Ubuntu 16.04: $ubuntu_16_count / $recipe_count"
  print_no_recipes "${no_ubuntu_16_recipes[@]}"
  echo "  Ubuntu 18.04: $ubuntu_18_count / $recipe_count"
  print_no_recipes "${no_ubuntu_18_recipes[@]}"
  echo "  OS X: $osx_count / $recipe_count"
  print_no_recipes "${no_osx_recipes[@]}"

  if [ "${#no_ubuntu_16_recipes[@]}" -gt 0 ] || [ "${#no_ubuntu_18_recipes[@]}" -gt 0 ] || [ "${#no_osx_recipes[@]}" -gt 0 ]; then
    return 1
  fi
}

run
