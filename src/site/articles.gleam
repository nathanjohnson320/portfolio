import gleam/list
import lustre/attribute.{class, href}
import lustre/element.{type Element, text}
import lustre/element/html.{a, article, div, h2, li, p, time, ul}
import site/app
import site/articles_data.{type Article, Article}

pub fn view(articles: List(Article)) -> Element(msg) {
  app.layout(
    "Articles",
    div([], [
      app.page_heading(
        "Writing on software, art, and everything in between.",
        "All of my long-form thoughts on programming, oil painting, and career — collected in chronological order.",
      ),
      ul([class("article-list")], list.map(articles, article_item)),
    ]),
  )
}

fn article_item(item: Article) -> Element(msg) {
  let Article(id:, title:, description:, date:, ..) = item
  li([], [
    article([class("article-card")], [
      h2([], [a([href("/articles/" <> id)], [text(title)])]),
      time([], [text(articles_data.format_date(date))]),
      p([], [text(description)]),
    ]),
  ])
}
