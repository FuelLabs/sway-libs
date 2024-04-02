# Libraries

There are several types of libraries that Sway Libs encompases. These include libraries that provide convenience functions, standards supporting libraries, data type libraries, security functionality libraries.

For implementation details on the libraries please see the [Sway Libs Docs](https://fuellabs.github.io/sway-libs/master/sway_libs/).

## [Assets Libraries](./asset_libraries.md)

Asset Libraries are any libraries that use [Native Assets](https://docs.fuel.network/docs/sway/blockchain-development/native_assets) on the Fuel Network.

### [Asset Library](./asset/index.md)

The [Asset](./asset/asset/index.md) Library provides helper functions for the [SRC-20](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-20.md), [SRC-3](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-3.md), and [SRC-7](https://github.com/FuelLabs/sway-standards/blob/master/SRCs/src-7.md) standards.

## [Access Control and Security Libraries](./access_security_libraries.md)

Access Control and Security Libraries are any libraries that are built and intended to provide additional safety when developing smart contracts.

### [Ownership Library](./ownership/index.md)

The [Ownership](./ownership/index.md) Library is used to apply restrictions on functions such that only a **single** user may call them.

### [Admin Library](./admin/index.md)

The [Admin](./admin/index.md) Library is used to apply restrictions on functions such that only a select few users may call them like a whitelist.

### [Pausable Library](./pausable/index.md)

The [Pausable](./pausable/index.md) Library allows contracts to implement an emergency stop mechanism.

### [Reentrancy Guard Library](./reentrancy/index.md)

The [Reentrancy Guard](./reentrancy/index.md) Library is used to detect and prevent reentrancy attacks.

## [Cryptography Libraries](./cryptography_libraries.md)

Cryptography Libraries are any libraries that provided cryptographic functionality beyond what the std-lib provides.

### [Bytecode Library](./bytecode/index.md)

The [Bytecode](./bytecode/index.md) Library is used for on-chain verification and computation of bytecode roots for contracts and predicates.

### [Merkle Library](./merkle/index.md)

The [Merkle Proof](./merkle/index.md) Library is used to verify Binary Merkle Trees computed off-chain.

## [Math Libraries](./math_libraries.md)

Math Libraries are libraries which provide mathematic functions or number types that are outside of the std-lib's scope.

### [Fixed Point Number Library](./fixed_point/index.md)

The [Fixed Point Number](./fixed_point/index.md) Library is an interface to implement fixed-point numbers.

### [Signed Integers](./signed_integers/index.md)

The [Signed Integers](./signed_integers/index.md) Library is an interface to implement signed integers.

## [Data Structures Libraries](./data_structures_libraries.md)

Data Structure Libraries are libraries which provide complex data structures which unlock additional functionality for Smart Contracts.

### [Queue](./queue/index.md)

The [Queue](./queue/index.md) Library is a linear data structure that provides First-In-First-Out (FIFO) operations.
