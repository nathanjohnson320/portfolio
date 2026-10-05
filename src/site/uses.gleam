import gleam/list
import lustre/attribute.{class}
import lustre/element.{type Element, text}
import lustre/element/html.{div, h2, h3, li, p, section, ul}
import site/app

type Tool {
  Tool(title: String, description: String)
}

type ToolSection {
  ToolSection(title: String, tools: List(Tool))
}

pub fn page() -> Element(msg) {
  let sections = [
    ToolSection("Workstation", [
      Tool(
        "14\" Starlabs Starbook",
        "I've been using this as my main machine for a while now and it's been great. It's not the most powerful machine in the world but it's more than enough for my needs. The keyboard is great and the battery life is amazing. Also runs elementary OS which is a great Linux distro.",
      ),
      Tool(
        "Keyboard.io Model 100 Keyboard",
        "This is the best keyboard I've ever used. It's a split keyboard with mechanical switches and a ton of programmable keys. It's also shaped like a butterfly which is cool.",
      ),
      Tool(
        "Kensington Expert Mouse Trackball",
        "I've been using a trackball for years and I'm never going back. I love the Expert Mouse because it has a scroll ring which is super useful.",
      ),
    ]),
    ToolSection("Development tools", [
      Tool(
        "Emacs",
        "Yeah I know, I'm one of those people. I've been using Emacs for years and I don't see myself switching anytime soon. I've got it configured just how I like it and I'm super productive with it. And yes I switch to VS Code when I need to pair program with someone.",
      ),
      Tool(
        "SQLTools",
        "Great VS Code extension for working with databases. I use it a lot and it's saved me a ton of time.",
      ),
      Tool(
        "Copilot",
        "Honestly one of the best tools I've ever used. It's like having a pair programmer that never gets tired and 90% has the perfect code snippet. 60% of the time it works every time.",
      ),
    ]),
    ToolSection("Design", [
      Tool(
        "Lucid",
        "Lucid is a great tool for creating diagrams and flowcharts. I use it pretty often for database ERDs and system diagrams. It's simple and fast and easy to embed in corporate tools like Confluence.",
      ),
    ]),
  ]

  app.layout(
    "Uses",
    div([], [
      app.page_heading(
        "Tools that I use to build software, stay productive, or just enjoy in general.",
        "I get asked a lot about the things I use to build software, stay productive, or buy to fool myself into thinking I'm being productive when I'm really just procrastinating. Here's a big list of all of my favorite stuff.",
      ),
      div([class("uses-sections")], list.map(sections, render_section)),
    ]),
  )
}

fn render_section(sec: ToolSection) -> Element(msg) {
  let ToolSection(title:, tools:) = sec
  section([class("uses-section")], [
    h2([], [text(title)]),
    ul([], list.map(tools, render_tool)),
  ])
}

fn render_tool(tool: Tool) -> Element(msg) {
  let Tool(title:, description:) = tool
  li([class("tool")], [
    h3([], [text(title)]),
    p([], [text(description)]),
  ])
}
