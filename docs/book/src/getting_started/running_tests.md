# Running Tests

There are two sets of tests that should be run: inline tests and sdk-harness tests. Please make sure you are using `forc v0.62.0` and `fuel-core v0.31.0`. You can check what version you are using by running the `fuelup show` command.

Make sure you are in the source directory of this repository `sway-libs/<you are here>`.

Run the inline tests:

```bash
forc test --path libs --release --locked
```

Once these tests have passed, run the sdk-harness tests:

```bash
forc test --path tests --release --locked && cargo test --manifest-path tests/Cargo.toml
```

> **NOTE:**
> This may take a while depending on your hardware, future improvements to Sway will decrease build times. After this has been run once, individual test projects may be built on their own to save time.
