#!/usr/bin/env bash

# Builds all the libraries located in the `./libs` folder, in parallel.
#
# Any arguments passed to this script are forwarded as-is to `forc build`, e.g.:
#
#     ./scripts/build-libs.sh --release --experimental dynamic_storage
#
# See `build.sh` for the full behavior.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "${SCRIPT_DIR}/build.sh" libs library "$@"
