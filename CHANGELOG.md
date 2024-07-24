# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased] - yyyy-mm-dd

Description of the upcoming release here.

### Added

- [#259](https://github.com/FuelLabs/sway-libs/pull/259) Adds a new upgradability library, including associated tests and documentation.
- [#265](https://github.com/FuelLabs/sway-libs/pull/265) Adds the `SetMetadataEvent` and emits `SetMetadataEvent` when the `_set_metadata()` function is called.

### Changed

- [#265](https://github.com/FuelLabs/sway-libs/pull/265) Enables the metadata events now that the Rust SDK supports wrapped heap types.

### Fixed

- [#258](https://github.com/FuelLabs/sway-libs/pull/258) Fixes incorrect instructions on how to run tests in README and docs hub.
- [#262](https://github.com/FuelLabs/sway-libs/pull/262) Fixes incorrect ordering comparison for IFP64, IFP128 and IFP256.

#### Breaking

- Some breaking change here 1
- Some breaking change here 2
