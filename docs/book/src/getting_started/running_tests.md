# Running Tests

There are two sets of tests that should be run: inline tests and sdk-harness tests.

In order to run the inline tests, make sure you are in the `libs/` folder of this repository `sway-libs/libs/<you are here>`.

Run the tests:

```bash
forc test
```

Once these tests have passed, make sure you are in the `tests/` folder of this repository `sway-libs/tests/<you are here>`.

Run the tests:

```bash
forc test && cargo test
```

> **NOTE:**
> This may take a while depending on your hardware, future improvements to Sway will decrease build times. After this has been run once, individual test projects may be built on their own to save time.
