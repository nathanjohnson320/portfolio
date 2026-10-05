import gleam/list
import lustre/attribute.{alt, class, href, src}
import lustre/element.{type Element, text}
import lustre/element/html.{a, div, h2, img, li, p, span, ul}
import site/app

type Project {
  Project(
    name: String,
    description: String,
    href: String,
    label: String,
    logo: String,
  )
}

pub fn page() -> Element(msg) {
  let projects = [
    Project(
      "My Art Store",
      "A simple e-commerce website that sells art prints and paintings.",
      "https://shop.paintbynate.art",
      "shop.paintbynate.art",
      "/img/logos/shop-logo.jpg",
    ),
    Project(
      "html-to-lustre",
      "Website that converts HTML to Lustre code for use in gleam+lustre apps.",
      "https://html-to-lustre.pages.dev/",
      "html-to-lustre",
      "/img/logos/elm-logo.png",
    ),
    Project(
      "clerk-elixir",
      "API SDK for the clerk.js authentication platform written in Elixir.",
      "https://github.com/nathanjohnson320/clerk_elixir",
      "github.com",
      "/img/logos/clerk-logo.png",
    ),
    Project(
      "agora",
      "Elixir package that implements the agora SDK's token signing for Access Keys",
      "https://github.com/nathanjohnson320/agora",
      "github.com",
      "/img/logos/agora-logo.png",
    ),
    Project(
      "LivePlace",
      "It's the same as reddit's r/place but written in Elixir + Phoenix LiveView.",
      "https://github.com/nathanjohnson320/live_place",
      "github.com",
      "/img/logos/liveplace-logo.png",
    ),
  ]

  app.layout(
    "Projects",
    div([], [
      app.page_heading(
        "Public projects I've worked on over the years.",
        "I have undertaken numerous projects over the past decade, and the following are those of which I've gotten the most satisfaction out of. These projects are open-source, allowing for public access and contribution. Should any of these projects capture your interest, I encourage you to review the code and contribute any ideas for improvement.",
      ),
      ul([class("project-grid")], list.map(projects, project_card)),
    ]),
  )
}

fn project_card(project: Project) -> Element(msg) {
  let Project(name:, description:, href: url, label:, logo:) = project
  li([class("project-card")], [
    img([src(logo), alt(""), class("project-logo")]),
    h2([], [a([href(url)], [text(name)])]),
    p([], [text(description)]),
    p([class("project-link")], [span([], [text(label)])]),
  ])
}
