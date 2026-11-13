# Portfolio + Blog

Static site built with [Selm](https://selm.nathanjohnson320.workers.dev/) (BEAM Html SSR + `selm export`), deployed to Cloudflare.

## Prerequisites

- Erlang/OTP **29** (see [`.tool-versions`](.tool-versions))
- [Wrangler](https://developers.cloudflare.com/workers/wrangler/install-and-update/) on `PATH` (for `selm deploy`)
- The Selm CLI on `PATH` — see the [quick start](https://selm.nathanjohnson320.workers.dev/docs/quick-start)

## Getting started

```bash
selm generate_articles   # content/articles → Generated/Articles.selm (+ CSS embed)
selm check
selm export --out public
selm run                 # preview at http://127.0.0.1:3000
```

Open [http://127.0.0.1:3000](http://127.0.0.1:3000).

`generate_articles` must run whenever markdown under `content/articles/` or `static/styles.css` changes.

## Deploy

```bash
selm deploy
```

Runs `generate_articles`, `export --out public`, then `wrangler deploy`.
