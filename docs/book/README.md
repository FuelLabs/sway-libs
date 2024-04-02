## Installation

If you wish to alter the documentation presented in this book then follow the following instructions.

1. Install [Rust](https://www.rust-lang.org/tools/install) if it's not installed.
2. Install [mdbook](https://rust-lang.github.io/mdBook/).

   ```bash
   cargo install mdbook
   ```

3. To [build](https://rust-lang.github.io/mdBook/cli/build.html) the book make sure that you are in `/.docs/book` and run

   ```bash
   mdbook build
   ```

4. To develop the book in real time, in the browser, run

   ```bash
   mdbook serve --open
   ```

## How to edit the book

Each page is written in markdown so there's not much to learn specifically for `mdbook` but you're free to read their documentation for additional information.

If you wish to add a new page then it must be listed in the [SUMMARY.md](src/SUMMARY.md).
