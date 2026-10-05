# Portfolio + Blog

Static site built with [Gleam](https://gleam.run) and [Lustre SSG](https://github.com/lustre-labs/ssg), deployed to Cloudflare Pages.

## Getting started

```bash
gleam deps download
gleam run -m build
gleam run -m dev
```

Open [http://localhost:8999](http://localhost:8999).

## Deploy

```bash
gleam run -m build
npm install
npm run deploy
```
