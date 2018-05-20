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

for recipe in $yapsh_dir/recipes/*; do
  if [[ -f "$recipe" ]]; then
    _basename="$(basename "$recipe")"
    if grep -q 'is_ubuntu_16_04' "$recipe"; then
      ubuntu_16_count=$((ubuntu_16_count+1))
    else
      no_ubuntu_16_recipes+=("$_basename")
    fi
    if grep -q 'is_ubuntu_18_04' "$recipe"; then
      ubuntu_18_count=$((ubuntu_18_count+1))
    else
      no_ubuntu_18_recipes+=("$_basename")
    fi
    if grep -q 'is_osx' "$recipe"; then
      osx_count=$((osx_count+1))
    else
      no_osx_recipes+=("$_basename")
    fi
    recipe_count=$((recipe_count+1))
  fi
done

function print_no_recipes() {
  local -a arr=("$@")
  for item in "${arr[@]}"; do
    echo "    - ✘ $item"
  done
}

echo "OS Coverages:"
echo "  Ubuntu 16.04: $ubuntu_16_count / $recipe_count"
print_no_recipes "${no_ubuntu_16_recipes[@]}"
echo "  Ubuntu 18.04: $ubuntu_18_count / $recipe_count"
print_no_recipes "${no_ubuntu_18_recipes[@]}"
echo "  OS X: $osx_count / $recipe_count"
print_no_recipes "${no_osx_recipes[@]}"
