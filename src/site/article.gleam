import lustre/attribute.{class, href}
import lustre/element.{type Element, text}
import lustre/element/html.{a, article, div, h1, p, time}
import lustre/ssg/markdown
import site/app
import site/articles_data.{type Article, Article}

pub fn view(post: Article) -> Element(msg) {
  let Article(title:, date:, content:, ..) = post
  let body = markdown.render(content)

  app.layout(
    title,
    article([class("prose")], [
      p([class("back")], [a([href("/articles")], [text("← Articles")])]),
      h1([], [text(title)]),
      time([], [text(articles_data.format_date(date))]),
      div([class("article-body")], body),
    ]),
  )
}
