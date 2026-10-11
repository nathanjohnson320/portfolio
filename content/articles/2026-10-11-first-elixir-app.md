---
title = "My First Elixir App"
date = "2026-10-11"
description = "Reminiscing on my first production elixir app."
---

About 10 years ago I launched my first production elixir application at my old job at red ventures. In hindsight it wasn't anything super exciting, but for me at that time it was the most exciting thing I had ever made.


### The problem
We had an issue where content managers would update content on our websites to something that they weren't really allowed to say. Sometimes it would be stuff like guaranteeing a price or saying something about a specific discount in a specific state that wasn't applicable. Things like this. Obviously you have certain legal obligations you have to meet so you can't be putting out things that aren't accurate. Normally you could solve this by manual review but we had thousands of writings across tens of thousands of domains and sometimes an update to one page would affect hundreds of thousands of landing pages. We needed a way to validate that the content on certain pages was not changing.

### Naive Solution
Our first solution was a little node.js application that ran webdriver.io tests against configured pages with a user defined test suite. These tests were configured in a UI so our CX/product people could set up the tests themselves. They'd pick the websites and then specific text to check for and then also they could add a step to check the screenshot against a previous screenshot. At this point in the web a lot of people were doing SPAs that rendered terribly with zero serverside content so a simple web scrape download would work, hence the webdriver.io with a full browser. This worked fine for about 10 webpages but after this it failed miserably because node.js could not handle parallel work like that. There were tens of thousands of web pages to check. We needed a solution with maximum concurrency.

### The elixir pitch
Elixir was pretty new at this time, I had a couple of years of experience building hobby apps with it but nothing in a production environment. I knew it could handle a huge amount of concurrent requests so I spent a few days prototyping a solution that worked like this:

* Quantum job poller polled the tests to run on an interval
* Tests were enqueued to their own GenServer process under a general test supervisor
* The GenServer handled raw webdriver requests to a headless chrome browser and the state of the tests was maintained in the GenServer (this was before oban existed).
* Test results would post back to the DB as they completed so each step would have a pass/fail and a reason and the overall suite would also have a pass/fail

I proposed this to my manager and he said "sure let's do it". We had other options to use like AWS lambdas and stuff but the cloud cost of that was like 100x our elixir solution.

### How did it go

Overall things ran smoothly for a year or so. We ran over 2 million test suites across 40 million web pages. The only bottleneck we ran into was the resources of the browsers on our AWS EC2 instances but we eventually migrated to headless chrome and that cleared things right up. Elixir was never the problem, things just worked unsupervised for a long time. 

After a year and a half I got pulled onto some other project and the company said they didn't really need to maintain it anymore. It was put into the backlog and eventually shutdown, very sad.

But this is how tech goes. I dunno maybe it's different other places but every company I've worked at went this way. We worked on one other elixir app maybe I'll talk about that some other time.

### What Would I Do Differently

So if I were to build this today it would be ten billion times easier.

1. Oban is a thing. We don't need to hand roll our own version of it with GenServers.
2. Playwright is a thing and you can run it with headless browsers
3. More formal test spec. When I wrote it the tests were a JSON schema but it wasn't strictly enforced. Now I would pick an open_api schema that defined the test structure up front. Maybe I would plug that into playwright's MCP so they could define the tests in plain english then convert to that.
4. More layers in elixir. We did the app a little weird originally where the UI/API were PHP and node.js then the executor was elixir. I would just do the entire thing in elixir today.

So overall I'd have a vanilla phoenix app, oban jobs for each test, and the tests driven through headless playwright. The tests can even run on lambdas nowadays which makes all of this even easier.