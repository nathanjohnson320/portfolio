import lustre/attribute.{class, href, rel}
import lustre/element.{type Element, fragment, text}
import lustre/element/html.{
  a, div, footer, h1, header, li, link, main, nav, p, title, ul,
}

/// Shared page chrome: stylesheet, site header, footer.
pub fn layout(page_title: String, content: Element(msg)) -> Element(msg) {
  fragment([
    link([rel("stylesheet"), href("/styles.css")]),
    link([rel("icon"), href("/favicon.ico")]),
    title([], format_title(page_title)),
    header([class("site-header")], [
      div([class("container header-inner")], [
        a([href("/"), class("site-brand")], [text("Nathan Johnson")]),
        nav([class("site-nav")], [
          ul([], [
            nav_item("/about", "About"),
            nav_item("/articles", "Articles"),
            nav_item("/projects", "Projects"),
            nav_item("/uses", "Uses"),
          ]),
        ]),
      ]),
    ]),
    main([class("site-main")], [div([class("container")], [content])]),
    footer([class("site-footer")], [
      div([class("container")], [
        p([], [
          text("© Nathan Johnson. "),
          a([href("/")], [text("Home")]),
        ]),
      ]),
    ]),
  ])
}

fn format_title(page_title: String) -> String {
  case page_title {
    "" -> "Nathan Johnson"
    t -> t <> " — Nathan Johnson"
  }
}

fn nav_item(path: String, label: String) -> Element(msg) {
  li([], [a([href(path)], [text(label)])])
}

pub fn page_heading(heading: String, intro: String) -> Element(msg) {
  div([class("page-heading")], [
    h1([], [text(heading)]),
    p([class("lede")], [text(intro)]),
  ])
}
