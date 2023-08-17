use std::process::{Command, Output};

use crate::util::spawn_and_wait;

const FORC: &str = "forc";
const FUELUP: &str = "fuelup";

/// Switch to the given fuel toolchain.
pub fn switch_fuel_toolchain(toolchain: String) {
    // Set the default toolchain to the one provided.
    let _ = spawn_and_wait(Command::new(FUELUP).arg("default").arg(toolchain));
}

/// Check the version of forc.
pub fn check_forc_version() -> String {
    let output = spawn_and_wait(Command::new(FORC).arg("--version"));
    std::str::from_utf8(&output.stdout).unwrap().to_string()
}

/// Use forc to build the project.
pub fn build_project(project_name: String) -> Output {
    spawn_and_wait(
        Command::new(FORC)
            .arg("build")
            .arg("--path")
            .arg(format!("projects/{}", project_name)),
    )
}
