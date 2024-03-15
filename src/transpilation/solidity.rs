use crate::util::spawn_and_wait;
use std::{path::PathBuf, process::{Command, Output}};

const CHARCOAL: &str = "charcoal";

/// Use forc to build the project.
pub fn run_charcoal(path: PathBuf) -> Output {
    spawn_and_wait(
        Command::new(CHARCOAL)
            .arg("--target")
            .arg(path.to_string_lossy().to_string()),
    )
}
