# Portfolio + Blog

Static site built with [Selm](https://github.com/nathanjohnson320/selm) (BEAM Html SSR + `selm export`), deployed to Cloudflare.

This branch (`selm-poc`) ports the Gleam + Lustre SSG site to Selm to exercise basic Gleam use cases: multi-page static export, markdown articles, and shared layout.

## Prerequisites

- Erlang/OTP **29** (see [`.tool-versions`](.tool-versions))
- [Wrangler](https://developers.cloudflare.com/workers/wrangler/install-and-update/) on `PATH` (for `selm deploy`)
- A local **release** build of the Selm CLI:

```bash
cd /path/to/selm
cargo build --release -p selm --bin selm
export PATH="$PWD/target/release:$PATH"
```

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
