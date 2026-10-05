//! A simple wrapper around Node's built-in HTTP server.

import gleam/javascript/promise

/// Creates an HTTP server and starts listening on the given port.
/// The handler receives the request method and URL path, and returns a
/// Promise of `#(status_code, body, content_type)`.
/// Use "" for content_type to default to text/plain.
pub fn serve(
  port: Int,
  handler: fn(String, String) -> promise.Promise(#(Int, String, String)),
) -> Nil {
  create_and_listen(port, handler)
}

/// Helper for plain text responses.
pub fn text(status_code: Int, body: String) -> #(Int, String, String) {
  #(status_code, body, "")
}

/// Helper for HTML responses.
pub fn html(status_code: Int, body: String) -> #(Int, String, String) {
  #(status_code, body, "text/html; charset=utf-8")
}

/// Helper for CSS responses.
pub fn css(status_code: Int, body: String) -> #(Int, String, String) {
  #(status_code, body, "text/css; charset=utf-8")
}

/// Serve a file from disk (text or binary) with the correct content type.
/// Returns a 404 text response when the file is missing.
pub fn file(path: String) -> #(Int, String, String) {
  read_static_file(path)
}

/// Common status codes for convenience.
pub const ok = 200

pub const not_found = 404

pub const internal_error = 500

@external(javascript, "./server.ffi.js", "create_and_listen")
fn create_and_listen(
  port: Int,
  handler: fn(String, String) -> promise.Promise(#(Int, String, String)),
) -> Nil

@external(javascript, "./server.ffi.js", "read_static_file")
fn read_static_file(path: String) -> #(Int, String, String)
