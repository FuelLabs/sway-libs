#!/usr/bin/env bash

# Pass `--locked` when running this script in CI to ensure both cargo and forc
# lock files are up to date.
locked="$1"

# Grab the absolute path to this script.
test_dirs="tests/src/test_projects/*"

for test_dir in $test_dirs; do
  if [ -f "${test_dir}/Forc.toml" ]; then
    echo "Building test $test_dir..."
    forc build $locked -o temp -p "${test_dir}" && echo ✔
    if ! [[ -f temp ]]; then
      echo  "❌  Failed to build $test_dir"
      exit 1
    fi
    rm -f temp
  else
    echo "Skipping test $test_dir..."
  fi
done

echo "Successfully built all projects."
