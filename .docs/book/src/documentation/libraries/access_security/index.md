# Access Control and Security Libraries

Access Control and Security Libraries are any libraries that are built and intended to provide additional saftey when developing smart contracts.

For implementation details on the libraries please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/).

## Ownership Library

The [Ownership](./ownership/index.md) Library is used to apply restrictions on functions such that only a **single** user may call them.

## Admin Library

The [Admin](./admin/index.md) Library is used to apply restrictions on functions such that only a select few users may call them like a whitelist.

## Pausable Library

The [Pausable](./pausable/index.md) Library allows contracts to implement an emergency stop mechanism.

## Reentrancy Guard Library

The [Reentrancy Guard](./reentrancy/index.md) Library is used to detect and prevent reentrancy attacks.
