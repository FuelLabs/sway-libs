use regex::Regex;
use std::fs::File;
use std::io::Read;
use std::path::Path;
use std::process::{Command, Output, Stdio};

/// Check the version of forc.
pub fn spawn_and_wait(cmd: &mut Command) -> Output {
    // Pipe stdin, stdout, and stderr to the child.
    let child = cmd
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .expect("failed to spawn command");

    // Wait for the output.
    child
        .wait_with_output()
        .expect("failed to fetch command output")
}

/// Read a file from the IO.
pub fn read_file_contents(file_name: String) -> Vec<u8> {
    // Declare the path to the file.
    let path = Path::new(&file_name);

    // If the path does not exist, return not found.
    if !path.exists() {
        return String::from("Not Found!").into();
    }

    // Setup an empty vecotr of file content.
    let mut file_content = Vec::new();

    // Open the file.
    let mut file = File::open(&file_name).expect("Unable to open file");

    // Read the file's contents.
    file.read_to_end(&mut file_content).expect("Unable to read");

    // Return the file's contents.
    file_content
}

/// This replaces the full file paths in error messages with just the file name.
pub fn clean_error_content(content: String, filename: &str) -> std::string::String {
    let path_pattern = Regex::new(format!(r"(/).*(/{filename})").as_str()).unwrap();

    path_pattern.replace_all(&content, filename).to_string()
}
