# Library Structure

In order to navigate through a library easily, there needs to be a structure that compartmentalizes concepts. This means that code is grouped together based on some concept.

Here is an example structure that we follow for `Sway` files in the `src` directory.

```sway
src/
├── lib.sw
└── my_library/
    ├── data_structures.sw
    ├── errors.sw
    ├── events.sw
    ├── my_library.sw
    └── utils.sw
```

In the example above there are no directories, however, it may make sense for a project to categorize concepts differently such as splitting the `data_structures.sw` into a directory containing individual modules.

## data_structures.sw

Contains data structures written for your project.

- structs
- enums
- trait implementations

## errors.sw

Contains enums that are used in `require(..., MyError::SomeError)` statements.
The enums are split into individual errors e.g. `DepositError`, `OwnerError` etc.

```sway
{{#include ../code/connect_four/src/errors.sw:error}}
```

## events.sw

Contains structs definitions which are used inside `log()` statements.

```sway
{{#include ../code/connect_four/src/events.sw:event}}
```

## my_library.sw

This is the core of your library. It will host anything that is exposed for developers to use with an Application Binary Interface (`ABI`) as well as functions contracts or other libraries may call. You can think of this as the entry point which all other devs will use to interact with the library.

## utils.sw

Any private functions (helper functions) that your contracts use inside their functions.
