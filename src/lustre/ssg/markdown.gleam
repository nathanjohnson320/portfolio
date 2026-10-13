// IMPORTS ---------------------------------------------------------------------

import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/regexp.{Match}
import gleam/string
import lustre/element.{type Element}
import mork
import mork/document.{
  type Block, type Document, type ListItem, BlockQuote, BulletList, Code,
  Document, FootnoteData, HtmlBlock, ListItem, OrderedList,
}
import mork/to_lustre
import smalto
import smalto/grammar.{type Grammar}
import smalto/languages/bash
import smalto/languages/css
import smalto/languages/dockerfile
import smalto/languages/elixir
import smalto/languages/gleam as gleam_lang
import smalto/languages/html as html_lang
import smalto/languages/javascript
import smalto/languages/json
import smalto/languages/python
import smalto/languages/rust
import smalto/languages/sql
import smalto/languages/toml as toml_lang
import smalto/languages/typescript
import smalto/languages/yaml
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
/// Fenced code blocks are syntax-highlighted with smalto when a matching
/// grammar is available.
///
pub fn render(document: String) -> List(Element(msg)) {
  document
  |> content
  |> mork.parse
  |> highlight_document
  |> to_lustre.to_lustre
}

fn highlight_document(doc: Document) -> Document {
  Document(
    ..doc,
    blocks: highlight_blocks(doc.blocks),
    footnotes: dict.map_values(doc.footnotes, fn(_, note) {
      FootnoteData(..note, blocks: highlight_blocks(note.blocks))
    }),
  )
}

fn highlight_blocks(blocks: List(Block)) -> List(Block) {
  list.map(blocks, highlight_block)
}

fn highlight_block(block: Block) -> Block {
  case block {
    Code(lang, text) ->
      case grammar_for(lang) {
        Some(grammar) ->
          case try_highlight(text, grammar, smalto.to_html) {
            Ok(html) -> HtmlBlock(code_html(lang, html))
            // Fall back if a grammar blows up on odd input (e.g. @tailwind)
            Error(_) -> block
          }
        None -> block
      }
    BlockQuote(blocks) -> BlockQuote(highlight_blocks(blocks))
    BulletList(pack, items) ->
      BulletList(pack, list.map(items, highlight_list_item))
    OrderedList(pack, items, start) ->
      OrderedList(pack, list.map(items, highlight_list_item), start)
    _ -> block
  }
}

@external(javascript, "./highlight.ffi.js", "try_highlight")
fn try_highlight(
  code: String,
  grammar: Grammar,
  to_html: fn(String, Grammar) -> String,
) -> Result(String, Nil)

fn highlight_list_item(item: ListItem) -> ListItem {
  ListItem(..item, blocks: highlight_blocks(item.blocks))
}

fn code_html(lang: Option(String), highlighted: String) -> String {
  let class = case lang {
    Some(name) if name != "" -> " class=\"language-" <> name <> "\""
    _ -> ""
  }
  "<pre><code" <> class <> ">" <> highlighted <> "</code></pre>\n"
}

fn grammar_for(lang: Option(String)) -> Option(Grammar) {
  case option.map(lang, string.lowercase) |> option.unwrap("") {
    "elixir" | "ex" | "exs" -> Some(elixir.grammar())
    "javascript" | "js" -> Some(javascript.grammar())
    "typescript" | "ts" -> Some(typescript.grammar())
    "css" -> Some(css.grammar())
    "bash" | "sh" | "shell" | "zsh" -> Some(bash.grammar())
    "docker" | "dockerfile" -> Some(dockerfile.grammar())
    "gleam" -> Some(gleam_lang.grammar())
    "html" -> Some(html_lang.grammar())
    "json" -> Some(json.grammar())
    "python" | "py" -> Some(python.grammar())
    "rust" | "rs" -> Some(rust.grammar())
    "sql" -> Some(sql.grammar())
    "toml" -> Some(toml_lang.grammar())
    "yaml" | "yml" -> Some(yaml.grammar())
    _ -> None
  }
}
