import filepath
import gleam/dict
import gleam/int
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import lustre/ssg/markdown
import simplifile
import tom

pub type Article {
  Article(
    id: String,
    title: String,
    description: String,
    date: String,
    content: String,
  )
}

fn articles_dir() -> String {
  case simplifile.current_directory() {
    Ok(cwd) -> filepath.join(cwd, "content/articles")
    Error(_) -> "content/articles"
  }
}

fn is_article_file(path: String) -> Bool {
  string.ends_with(path, ".md")
}

fn article_id_from_path(path: String) -> String {
  path
  |> filepath.base_name
  |> filepath.strip_extension
}

fn parse_article(file_path: String, raw: String) -> Result(Article, String) {
  let id = article_id_from_path(file_path)

  let metadata = case markdown.frontmatter(raw) {
    Ok(frontmatter) ->
      case tom.parse(frontmatter) {
        Ok(parsed) -> parsed
        Error(_) -> dict.new()
      }
    Error(_) -> dict.new()
  }

  let title = case tom.get_string(metadata, ["title"]) {
    Ok(t) -> t
    Error(_) -> id
  }

  let description = case tom.get_string(metadata, ["description"]) {
    Ok(d) -> d
    Error(_) -> ""
  }

  let date = case tom.get_string(metadata, ["date"]) {
    Ok(d) -> d
    Error(_) -> ""
  }

  Ok(Article(
    id: id,
    title: title,
    description: description,
    date: date,
    content: raw,
  ))
}

/// Load all articles from content/articles/*.md, newest first.
pub fn load() -> Result(List(Article), String) {
  let dir = articles_dir()

  use files <- result.try(
    simplifile.get_files(dir)
    |> result.map_error(fn(e) { simplifile.describe_error(e) }),
  )

  let article_files =
    list.filter(files, is_article_file)
    |> list.sort(string.compare)

  use articles <- result.try(
    list.try_map(article_files, fn(file_path) {
      use content <- result.try(
        simplifile.read(file_path)
        |> result.map_error(fn(e) { simplifile.describe_error(e) }),
      )
      parse_article(file_path, content)
    }),
  )

  Ok(list.sort(articles, compare_by_date_desc))
}

fn compare_by_date_desc(a: Article, b: Article) -> order.Order {
  // ISO dates sort lexicographically; reverse for newest first
  order.negate(string.compare(a.date, b.date))
}

pub fn format_date(date: String) -> String {
  case string.split(date, "-") {
    [year, month, day] -> {
      let month_name = case int.parse(month) {
        Ok(1) -> "January"
        Ok(2) -> "February"
        Ok(3) -> "March"
        Ok(4) -> "April"
        Ok(5) -> "May"
        Ok(6) -> "June"
        Ok(7) -> "July"
        Ok(8) -> "August"
        Ok(9) -> "September"
        Ok(10) -> "October"
        Ok(11) -> "November"
        Ok(12) -> "December"
        _ -> month
      }
      case int.parse(day) {
        Ok(d) -> month_name <> " " <> int.to_string(d) <> ", " <> year
        Error(_) -> date
      }
    }
    _ -> date
  }
}
