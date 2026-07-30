#!/usr/bin/env bash

# Builds the examples located in the `./examples` folder. The examples are a
# single workspace, so building it builds all of its member projects.
#
# Any arguments passed to this script are forwarded as-is to `forc build`, e.g.:
#
#     ./scripts/build-examples.sh --release --experimental dynamic_storage
#
# See `build.sh` for the full behavior.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "${SCRIPT_DIR}/build.sh" examples example "$@"
