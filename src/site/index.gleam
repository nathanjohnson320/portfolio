import gleam/list
import lustre/attribute.{alt, class, href, src}
import lustre/element.{type Element, text}
import lustre/element/html.{
  a, article, div, h1, h2, img, li, ol, p, span, time, ul,
}
import site/app
import site/articles_data.{type Article, Article}

pub fn page(articles: List(Article)) -> Element(msg) {
  let latest = list.take(articles, 4)

  app.layout(
    "",
    div([], [
      div([class("hero")], [
        h1([], [
          text("Software engineer, entrepreneur, and professional artist."),
        ]),
        p([class("lede")], [
          text(
            "I'm Nathan, a software engineer and oil painter based in Tallinn Estonia. I'm currently working with STORD building out the cloud supply chain and oil painting on my YouTube channel in my free time.",
          ),
        ]),
        ul([class("social-links")], [
          social("https://www.instagram.com/paint.by.nate/", "Instagram"),
          social("https://github.com/nathanjohnson320", "GitHub"),
          social(
            "https://www.linkedin.com/in/nathan-johnson-b8659562/",
            "LinkedIn",
          ),
          social("https://x.com/PaintByNate", "X"),
        ]),
      ]),
      photos(),
      div([class("home-grid")], [
        div([class("home-articles")], list.map(latest, article_card)),
        resume(),
      ]),
    ]),
  )
}

fn social(url: String, label: String) -> Element(msg) {
  li([], [a([href(url)], [text(label)])])
}

fn photos() -> Element(msg) {
  div([class("photo-strip")], [
    photo_frame("/img/photos/image-1.jpg"),
    photo_frame("/img/photos/image-2.jpg"),
    photo_frame("/img/photos/image-3.jpg"),
    photo_frame("/img/photos/image-4.jpg"),
    photo_frame("/img/photos/image-5.jpg"),
  ])
}

fn photo_frame(src_path: String) -> Element(msg) {
  div([class("photo-frame")], [
    img([src(src_path), alt(""), class("photo")]),
  ])
}

fn article_card(item: Article) -> Element(msg) {
  let Article(id:, title:, description:, date:, ..) = item
  article([class("article-card")], [
    h2([], [a([href("/articles/" <> id)], [text(title)])]),
    time([], [text(articles_data.format_date(date))]),
    p([], [text(description)]),
    p([class("read-more")], [
      a([href("/articles/" <> id)], [text("Read article →")]),
    ]),
  ])
}

fn resume() -> Element(msg) {
  div([class("resume")], [
    h2([], [text("Work")]),
    ol([class("roles")], [
      role(
        "STORD",
        "Senior Fullstack Engineer",
        "/img/logos/stord.png",
        "2021",
        "Present",
      ),
      role(
        "Sprout ITAD",
        "Senior Software Engineer",
        "/img/logos/sprout.png",
        "2020",
        "2021",
      ),
      role(
        "Passport",
        "Software Engineer III",
        "/img/logos/passport.png",
        "2019",
        "2020",
      ),
      role(
        "Red Ventures",
        "Senior Software Engineer",
        "/img/logos/red-ventures.png",
        "2014",
        "2019",
      ),
    ]),
    p([class("cv-link")], [
      a([href("/files/nathan-johnson-resume.pdf")], [text("Download CV")]),
    ]),
  ])
}

fn role(
  company: String,
  title: String,
  logo: String,
  start: String,
  end: String,
) -> Element(msg) {
  li([class("role")], [
    img([src(logo), alt(""), class("role-logo")]),
    div([], [
      span([class("role-company")], [text(company)]),
      span([class("role-title")], [text(title)]),
      span([class("role-dates")], [text(start <> " — " <> end)]),
    ]),
  ])
}
