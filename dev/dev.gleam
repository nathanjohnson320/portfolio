import filepath
import gleam/int
import gleam/io
import gleam/javascript/promise
import gleam/option
import gleam/string
import server
import simplifile

pub fn main() {
  let port = 8999
  io.println("Serving ./public at http://localhost:" <> int.to_string(port))
  server.serve(port, handle_request)
}

fn handle_request(
  _method: String,
  url: String,
) -> promise.Promise(#(Int, String, String)) {
  let path = path_from_url(url)
  case path {
    "" | "index" -> serve_html("./public/index.html") |> promise.resolve
    _ -> {
      let direct_html = filepath.join("./public", path <> ".html")
      let index_html =
        filepath.join(filepath.join("./public", path), "index.html")
      let html_path = case simplifile.is_file(direct_html) {
        Ok(True) -> option.Some(direct_html)
        _ ->
          case simplifile.is_file(index_html) {
            Ok(True) -> option.Some(index_html)
            _ -> option.None
          }
      }
      case html_path {
        option.Some(p) -> serve_html(p) |> promise.resolve
        option.None -> serve_static(path) |> promise.resolve
      }
    }
  }
}

fn path_from_url(url: String) -> String {
  url
  |> fn(s) {
    case string.contains(s, "?") {
      True -> {
        case string.split(s, "?") {
          [path, ..] -> path
          _ -> s
        }
      }
      False -> s
    }
  }
  |> fn(s) {
    case string.starts_with(s, "/") {
      True -> string.drop_start(s, 1)
      False -> s
    }
  }
  |> fn(s) {
    case string.ends_with(s, "/") {
      True -> string.drop_end(s, 1)
      False -> s
    }
  }
}

fn serve_html(path: String) -> #(Int, String, String) {
  case simplifile.read(path) {
    Ok(html) -> server.html(server.ok, html)
    Error(_) -> server.text(server.not_found, "Not found")
  }
}

fn serve_static(path: String) -> #(Int, String, String) {
  filepath.join("./public", path)
  |> server.file
}
