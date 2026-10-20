import lustre/attribute.{class, href}
import lustre/element.{type Element, text}
import lustre/element/html.{a, article, div, h1, h2, li, ol, p, time, ul}
import site/app

pub fn page() -> Element(msg) {
  app.layout(
    "Terms of Use",
    article([class("prose terms")], [
      h1([], [text("Terms of Use")]),
      time([], [text("Effective October 20, 2026")]),
      div([class("article-body")], [
        p([], [
          text(
            "This website (career.paintbynate.art and related pages) is a personal portfolio and writing space for Nathan Johnson. It is published for human visitors — people who read, browse, and occasionally get in touch. It is not a free data source for artificial intelligence systems.",
          ),
        ]),
        h2([], [text("No scraping, crawling, or automated collection")]),
        p([], [
          text(
            "You may not use any automated means to access, scrape, crawl, harvest, copy, download, or index this website or its content, except for ordinary search-engine indexing that is not used to train or improve generative AI systems. This includes bots, spiders, scrapers, agents, browser automation, bulk download tools, and any software acting on behalf of an AI or machine-learning system.",
          ),
        ]),
        h2([], [text("No AI or machine-learning use")]),
        p([], [
          text(
            "Without prior written permission from Nathan Johnson, you may not use any content from this site — text, images, code samples, metadata, or structure — to:",
          ),
        ]),
        ul([], [
          li([], [
            text(
              "Train, fine-tune, evaluate, or otherwise improve any AI, machine-learning, or large language model system",
            ),
          ]),
          li([], [
            text(
              "Build or expand retrieval-augmented generation (RAG) corpora, embeddings databases, or similar indexes for generative AI",
            ),
          ]),
          li([], [
            text(
              "Reproduce, summarize, or quote site content in automated AI-generated answers or products offered to third parties",
            ),
          ]),
          li([], [
            text(
              "Include site content in datasets sold, shared, or redistributed for AI development",
            ),
          ]),
        ]),
        p([], [
          text(
            "These restrictions apply whether or not a crawler respects robots.txt, ai.txt, llms.txt, or HTTP headers. Those files and tags state the site’s preferences; these Terms state the binding rules for anyone who accesses the site.",
          ),
        ]),
        h2([], [text("What humans may do")]),
        p([], [
          text(
            "You are welcome to read the articles, look at the projects, share a link with another person, and quote short passages with attribution for personal, educational, or journalistic purposes that do not involve AI training or automated redistribution. If you want to reuse something more substantial, ask first: ",
          ),
          a([href("mailto:nate@paintbynate.art")], [
            text("nate@paintbynate.art"),
          ]),
          text("."),
        ]),
        h2([], [text("Ownership")]),
        p([], [
          text(
            "Unless otherwise noted, Nathan Johnson owns the copyright and other rights in the content on this site. Accessing a page does not grant you a license to copy, scrape, or train on that content beyond the limited human uses described above.",
          ),
        ]),
        h2([], [text("Enforcement")]),
        p([], [
          text(
            "Unauthorized scraping or AI use may result in technical blocking, abuse reports to hosting and network providers, and any other remedies available under applicable law, including claims for copyright infringement and violation of these Terms. Continued access after notice of these Terms constitutes acceptance.",
          ),
        ]),
        h2([], [text("Signals to automated systems")]),
        p([], [
          text(
            "This site publishes machine-readable notices that reinforce the same policy:",
          ),
        ]),
        ol([], [
          li([], [
            a([href("/robots.txt")], [text("/robots.txt")]),
            text(" — known AI training crawlers are disallowed"),
          ]),
          li([], [
            a([href("/ai.txt")], [text("/ai.txt")]),
            text(" — training and scraping are disallowed"),
          ]),
          li([], [
            a([href("/llms.txt")], [text("/llms.txt")]),
            text(" — LLM / AI use is refused"),
          ]),
          li([], [
            text(
              "HTML meta robots and X-Robots-Tag headers include noai / noimageai where supported",
            ),
          ]),
        ]),
        p([], [
          text(
            "If you operate a crawler or AI product and believe you have a lawful basis or need an exception, contact ",
          ),
          a([href("mailto:nate@paintbynate.art")], [
            text("nate@paintbynate.art"),
          ]),
          text(" before collecting anything. Silence is not consent."),
        ]),
        h2([], [text("Changes")]),
        p([], [
          text(
            "These Terms may be updated from time to time. The effective date at the top of this page will change when they do. Continued use of the site after an update means you accept the revised Terms.",
          ),
        ]),
      ]),
    ]),
  )
}
