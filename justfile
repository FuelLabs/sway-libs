# lists the available recipes
default:
    @just --list --unsorted

alias bl := build-libs
# builds the libraries; additional arguments are forwarded to `forc build`, e.g.: `just bl --release`
build-libs *args:
    ./scripts/build-libs.sh {{ args }}

alias be := build-examples
# builds the examples; additional arguments are forwarded to `forc build`, e.g.: `just be --release`
build-examples *args:
    ./scripts/build-examples.sh {{ args }}

alias bt := build-tests
# builds the tests; additional arguments are forwarded to `forc build`, e.g.: `just bt --release`
build-tests *args:
    ./scripts/build-tests.sh {{ args }}

alias ba := build-all
# builds the libraries, the examples, and the tests; e.g.: `just ba --release`
build-all *args: (build-libs args) (build-examples args) (build-tests args)
