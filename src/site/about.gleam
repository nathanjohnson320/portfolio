import gleam/float
import gleam/int
import gleam/time/calendar
import gleam/time/duration
import gleam/time/timestamp.{type Timestamp}
import lustre/attribute.{alt, class, href, src}
import lustre/element.{type Element, text}
import lustre/element/html.{a, div, h1, img, li, p, ul}
import site/app

fn years_of_experience(start_year: Timestamp) -> String {
  let current_year = timestamp.system_time()
  let years_of_experience_in_seconds =
    timestamp.difference(start_year, current_year)
    |> duration.to_seconds()
    |> float.round()
  let years_of_experience = {
    years_of_experience_in_seconds / { 60 * 60 * 24 * 365 }
  }
  int.to_string(years_of_experience)
}

pub fn page() -> Element(msg) {
  app.layout(
    "About",
    div([class("about")], [
      img([
        src("/img/portrait.jpg"),
        alt("Portrait of Nathan Johnson"),
        class("portrait"),
      ]),
      div([class("about-copy")], [
        h1([], [
          text(
            "I'm Nathan Johnson. Currently working with STORD building out the cloud supply chain and oil painting on my YouTube channel in my free time.",
          ),
        ]),
        p([], [
          text(
            "I've been writing software for the last "
            <> years_of_experience(timestamp.from_calendar(
              date: calendar.Date(2012, calendar.August, 26),
              time: calendar.TimeOfDay(0, 0, 0, 0),
              offset: calendar.utc_offset,
            ))
            <> " years, and painting for the last "
            <> years_of_experience(timestamp.from_calendar(
              date: calendar.Date(2020, calendar.December, 10),
              time: calendar.TimeOfDay(0, 0, 0, 0),
              offset: calendar.utc_offset,
            ))
            <> " years. Used to live in Pineville with my cat KitKat right near downtown. Now I live in Tallinn, Estonia with my girlfriend and cat Louie.",
          ),
        ]),
        p([], [
          text(
            "My career in software has been focused on building web applications and APIs, working with a variety of technologies including everything from backend frameworks like Phoenix, Laravel, frontend libraries like React, data science transformers in Python for Stitch, and cloud services like AWS. I've even managed teams of up to 8 developers, and have started a couple of companies along the way (Tomahawk + Venu now RIP).",
          ),
        ]),
        p([], [
          text(
            "In 2020 I decided to learn oil painting inspired by the legendary Bob Ross, and have been sharing my journey on YouTube ever since. I focus on oil painting, and have a passion for landscapes and seascapes. I'm currently working on a series of paintings inspired by the Blue Ridge Mountains and hope to have them up in a gallery soon.",
          ),
        ]),
        p([], [
          text(
            "Today I'm working with STORD building out the cloud supply chain and oil painting on my YouTube channel in my free time. I'm always looking for new opportunities to learn and grow, so if you have any ideas or projects you'd like to collaborate on, please reach out!",
          ),
        ]),
        ul([class("social-list")], [
          social_item(
            "https://bsky.app/profile/nathanjohnson320.bsky.social",
            "Follow on Bluesky",
          ),
          social_item(
            "https://www.instagram.com/paint.by.nate/",
            "Follow on Instagram",
          ),
          social_item("https://github.com/nathanjohnson320", "Follow on GitHub"),
          social_item(
            "https://www.linkedin.com/in/%F0%9F%8D%BB-nathaniel-j-b8659562/",
            "Follow on LinkedIn",
          ),
          social_item("https://x.com/PaintByNate", "Follow on X"),
          social_item("mailto:nate@paintbynate.art", "nate@paintbynate.art"),
        ]),
      ]),
    ]),
  )
}

fn social_item(url: String, label: String) -> Element(msg) {
  li([], [a([href(url)], [text(label)])])
}
