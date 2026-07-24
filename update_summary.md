# Documentation update summary

## Why this update was needed

The reentrancy documentation made an overly broad claim that cross-contract
reentrancy was impossible because native-asset transfers do not invoke receiver
code. While the transfer observation is correct, an explicit external contract
call can transfer control into a direct or cyclic call path that reenters the
original contract.

## What changed

- Distinguished non-callback native-asset transfers from explicit
  cross-contract calls.
- Documented direct, cyclic, proxy, and fallback reentry paths.
- Recommended checks-effects-interactions and use of `reentrancy_guard()` when
  a recursive call path could violate an invariant.
- Clarified that the guard checks whether the current contract already appears
  in the active call stack.
- Clarified that the guard does not make arbitrary external calls safe and
  does not replace analysis of the complete call topology.
- Warned that pre-call storage snapshots may be stale after a reachable
  callback and are not protected merely by using the guard.
- Applied the same wording to the published book source and the reentrancy
  package README.

## Validation

- The wording was checked against the library's call-stack implementation.
- The Sway Libs mdBook built successfully.
- All committed changes pass `git diff --check`.
