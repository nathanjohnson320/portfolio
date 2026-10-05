// IMPORTS ---------------------------------------------------------------------

import gleam/bool
import gleam/dict.{type Dict}
import gleam/regexp.{Match}
import gleam/string
import lustre/element.{type Element}
import mork
import mork/to_lustre
import tom.{type Toml}

// QUERIES ---------------------------------------------------------------------

/// Extract the frontmatter string from a markdown document. Frontmatter is
/// anything between two lines of three dashes, like this:
///
/// ```markdown
/// ---
/// title = "My Document"
/// ---
///
/// # My Document
///
/// ...
/// ```
///
/// The document **must** start with exactly three dashes and a newline for there
/// to be any frontmatter. If there is no frontmatter, this function returns
/// `Error(Nil)`.
///
pub fn frontmatter(document: String) -> Result(String, Nil) {
  use <- bool.guard(!string.starts_with(document, "---"), Error(Nil))
  let options = regexp.Options(case_insensitive: False, multi_line: True)
  let assert Ok(re) = regexp.compile("^---\\n[\\s\\S]*?\\n---", options)

  case regexp.scan(re, document) {
    [Match(content: frontmatter, ..), ..] ->
      Ok(
        frontmatter
        |> string.drop_start(4)
        |> string.drop_end(4),
      )
    _ -> Error(Nil)
  }
}

/// Extract the TOML metadata from a markdown document. This takes the
/// [`frontmatter`](#frontmatter) and parses it as TOML. If there is *no*
/// frontmatter, this function returns an empty dictionary.
///
/// If the frontmatter is invalid TOML, this function returns a TOML parse error.
///
pub fn metadata(
  document: String,
) -> Result(Dict(String, Toml), tom.ParseError) {
  case frontmatter(document) {
    Ok(frontmatter) -> tom.parse(frontmatter)
    Error(_) -> Ok(dict.new())
  }
}

/// Extract the markdown content from a document with optional frontmatter. If
/// the document does not have frontmatter, this acts as an identity function.
///
pub fn content(document: String) -> String {
  let toml = frontmatter(document)

  case toml {
    Ok(toml) -> string.replace(document, "---\n" <> toml <> "\n---", "")
    Error(_) -> document
  }
}

// CONVERSIONS -----------------------------------------------------------------

/// Render a markdown document to Lustre elements. If the document contains
/// [`frontmatter`](#frontmatter) it is stripped out before parsing.
///
pub fn render(document: String) -> List(Element(msg)) {
  document
  |> content
  |> mork.parse
  |> to_lustre.to_lustre
}
