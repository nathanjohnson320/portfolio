---
title = "Punching Above Your Weight"
date = "2026-11-04"
description = "Why do we care, cognitive offloading, and why engineering culture is dying"
---

One of my coworkers shared a really interesting video with me yesterday and one of the things that was mentioned was that there's both responsible and irresposible AI use. Responsible AI use is when you understand the system you are working on and implement a change with AI within the bounds of your understanding. Irresponsible AI use is using AI when you don't understand what you are working on and use AI to build the thing anyway. A lot of what I am seeing inside and outside my job (at least in the USA markets) is the irresponsible end. That's what I would call punching above your weight.

### Why do we care

Punching above your weight has a slew of horrible side effects which you can probably already see before even reading this. If you don't understand how to do something, but a tool allows you to do it anyway, when the tool stops working and the product breaks you are now permanently stuck. You don't understand what you've built so you cannot understand how to fix it. What's worse, is probably when the current VC backing of AI runs out and every single AI cloud provider goes up 100x in price.

I see this a lot at my current job. Someone builds some crazy feature or random app with claude. The feature breaks. Then they go back and forth 90 times with claude saying "claude plz halp fix i no understand". This costs them like $20 in tokens today. In a year? Who knows maybe that's a $800 fix. At some point this cognitive gap will absolutely catch up.

The only times I will punch above my weight are when I want to do something that I know is really really really far fetched, and then see how close I can get to making that a reality. An example of this is I recently saw acadia, the elm backend. I liked the idea of elm on the server but thought the implementation didn't really make sense from someone who has built backend services for 10+ years so I spent my remaining personal cursor tokens on an implementation of backend elm that compiles to beam code. I don't plan to ever put this in production so I feel like that use case is someone responsible? idk though let me know what you think lmao.

## Cognitive offloading

For myself at my current job punching above my weight isn't such a huge issue because I've worked on things so long I usually know the service and module where problems are, I've been doing elixir for 10 years, the UI hasn't really changed that much since then, so like for me implementing a new table or api or whatever is basically copy paste anyway. I am essentially never challenged and always punching under my weight here, so under that I think it's ok to offload my grind tasks to an LLM. One thing I do notice however, is that the more I use an LLM to do things at my job, the less I remember what I worked on. This may be due to the volume of tasks I'm able to complete now that I do so many things so quickly they never end up in my mid or long term memory. It may also be the burn out contributing as well. I'm not really sure. But this is something I've started to keep an eye on.

## Engineering culture is dying

This is the thing I've noticed that makes me the most sad. The main reason I enjoy engineering or programming at all is that it gave me an outlet to talk to people at my regular job. I am not a person who actively seeks out conversations with folks, like at conferences I usually am just off on my own somewhere. But at my day job it was really nice to hop on a zoom or google meet and talk about random problems that I have or technical solutions I might have for other people's problems then get feedback and improve. 

With claude this has been completely killed. My team doesn't talk anymore. They talk to claude and only claude. When they reply in slack, the reply is also claude generated. There's no collaboration with humans only claude and it is super depressing. I can understand why this happened, because it's way easier for a person to type in a message box and get a reply instantly than it is to message someone on slack or sit on a call for an hour and not get anywhere. But I feel like we lost the plot. The vibes are off and everyone seems sad about this but it's mandated from a company toplevel everywhere. Every company I see is operating this way and it's just very very sad.

Well as always, we'll see how this goes.