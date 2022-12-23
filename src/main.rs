use fs_extra::dir::{copy, CopyOptions};
use hex::encode;
use hyper::body::HttpBody;
use hyper::service::{make_service_fn, service_fn};
use hyper::{Body, Request, Response, Server, StatusCode};
use nanoid::nanoid;
use serde_json::json;
use std::fs::{create_dir, read_to_string, remove_dir_all, File};
use std::io::prelude::*;
use std::path::Path;
use std::process::{Command, Stdio};
use std::{convert::Infallible, net::SocketAddr};
use regex::Regex;

// Copy the template project to a new project.
fn create_project() -> Result<std::string::String, fs_extra::error::Error> {
    // Create a new project id.
    let project_name = nanoid!();

    // Create a new directory for the project.
    create_dir(format!("projects/{}", project_name))?;

    // Setup the copy options for copying the template project to the new dir.
    let options = CopyOptions {
        overwrite: false,
        skip_exist: false,
        buffer_size: 64000,
        copy_inside: false,
        content_only: true,
        depth: 0,
    };

    // Copy the template project over to the new directory.
    copy(
        "projects/swaypad",
        format!("projects/{}", project_name.to_owned()),
        &options,
    )?;

    // Return the project id.
    Ok(project_name.to_owned())
}

// Remove a project from the projects dir.
fn remove_project(project_name: String) -> std::io::Result<()> {
    remove_dir_all(format!("projects/{}", project_name))?;
    Ok(())
}

// Write the main sway file to a project.
fn write_main_file(project_name: String, contract: &[u8]) -> std::io::Result<()> {
    let mut file = File::create(format!("projects/{}/src/main.sw", project_name))?;
    file.write_all(contract)?;
    Ok(())
}

// Read a file from the IO.
fn read_file_contents(file_name: String) -> Vec<u8> {
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

    // Read the files contents.
    file.read_to_end(&mut file_content).expect("Unable to read");

    // Return the files contents.
    file_content
}

// This is a hack and should be made reletive or removed.
fn clean_error_content(content: String) -> std::string::String {
    let path_pattern = Regex::new(r"(/).*(/main.sw)").unwrap();

    path_pattern.replace_all(&content, "/main.sw").to_string()
}

// Build and destroy a project.
fn build_and_destroy_project(contract: &[u8]) -> (String, String, String) {
    // Check if any contract has been submitted.
    if contract.len() == 0 {
        return ("".to_string(), "".to_string(), "No contract.".to_string());
    }

    // Create a new project.
    let project_name = create_project().unwrap();

    // Write the main file based upon the contract content above and project id.
    write_main_file(project_name.to_owned(), contract).unwrap();

    // Use forc build to build the project.
    let child = Command::new("forc")
        .arg("build")
        .arg("--path")
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .arg(format!("projects/{}", project_name.to_owned()))
        .spawn()
        .expect("failed to execute child");

    // Wait for the output of forc build.
    let output = child.wait_with_output().expect("failed to wait on child");

    // Determine if the project was build successfully.
    let is_compiled = output.status.success();

    // If the project compiled.
    if is_compiled {
        // Read the ABI data file which was outputed from the build.
        let abi = read_to_string(format!(
            "projects/{}/out/debug/swaypad-abi.json",
            project_name.to_owned()
        ))
        .expect("Should have been able to read the file");

        // Read the file contents from the outputed bin file.
        let k = read_file_contents(format!(
            "projects/{}/out/debug/swaypad.bin",
            project_name.to_owned()
        ));

        // Remove the project directory and contents.
        remove_project(project_name.to_owned()).unwrap();

        // Return the abi, bin and empty error message.
        return (
            clean_error_content(String::from(abi)),
            clean_error_content(encode(k)),
            String::from(""),
        );
    } else {
        // Get the error message presented in the console output.
        let error = std::str::from_utf8(&output.stderr).unwrap();

        // Get the index of the main file.
        let main_index = error.find("/main.sw:").unwrap();

        // Truncate the error message to only include the relevant content.
        let trunc = String::from(error).split_off(main_index);

        // Remove the project.
        remove_project(project_name.to_owned()).unwrap();

        // Return an empty abi, bin and the error message.
        return (
            String::from(""),
            String::from(""),
            clean_error_content(String::from(trunc)),
        );
    }
}

// Create the Hyper handler for the compile request.
async fn handle(_req: Request<Body>) -> Result<Response<Body>, Infallible> {
    // Build a response body message.
    let mut body = Body::from(
        json!({
            "abi": "",
            "bytecode": "",
            "error": "No contract."
        })
        .to_string(),
    );

    // Get the body data as a vector.
    match _req.into_body().data().await {
        None => {},
        Some(result) => {
            match result {
                Err(hyper::Error { .. }) => {},
                Ok(value) => {
                    // Convert the body data to a string.
                    let my_string = String::from_utf8(value.to_vec()).unwrap();
        
                    // Build and destroy a project, return the relevant abi, bytecode and error.
                    let (abi, bytecode, error) = build_and_destroy_project(String::from(my_string).as_bytes());
        
                    body = Body::from(
                        json!({
                            "abi": abi,
                            "bytecode": bytecode,
                            "error": error
                        })
                        .to_string(),
                    );
                }
            }
        } 
    }

    // Return the response built with CORS headers set.
    let response = Response::builder()
        .status(StatusCode::OK)
        .header("Access-Control-Allow-Origin", "*")
        .header("Access-Control-Allow-Headers", "*")
        .header("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
        .body(body);
    Ok(response.unwrap())
}

/*
This will be for saving to a Gist file.

curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer <YOUR-TOKEN>"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/gists \
  -d '{"description":"Example of a gist","public":false,"files":{"README.md":{"content":"Hello World"}}}'
  */

#[tokio::main]
async fn main() {
    // Bond the server at port 80.
    let addr = SocketAddr::from(([0, 0, 0, 0], 80));

    // Make the Hyper service.
    let make_svc = make_service_fn(|_conn| async { Ok::<_, Infallible>(service_fn(handle)) });
    let server = Server::bind(&addr).serve(make_svc);

    // Return error if there is an issue.
    if let Err(e) = server.await {
        eprintln!("server error: {}", e);
    }
}
