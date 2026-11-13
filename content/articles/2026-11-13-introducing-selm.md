---
title = "Introducing selm"
date = "2026-11-13"
description = "Write one familiar language. Compile it to JavaScript for interactive apps, to Erlang for servers, databases, and HTML on the BEAM, or to AtomVM for microcontrollers. Start small, then grow into full-stack."
---

I've been working on this for some time and I think it has enough usable features to at least put into this blog for now. But I have an Elm flavoured language to introduce.

```selm
module Main exposing (handle, main)

import Counter exposing (Msg)
import Process
import Server exposing (Request, Response)
import Server.Route as Route exposing
    ( Total
    , get
    , map
    , methodNotAllowed
    , notFound
    , oneOf
    , post
    , s
    , top
    )
import String
import Supervisor exposing (OneForOne)
import Ui.Counter exposing (page)

main : Program () Int Msg
main =
    Server.application
        { init = Counter.init
        , update = Counter.update
        , subscriptions = Counter.subscriptions
        , handle = handle
        , supervisor = Supervisor.new OneForOne
        , config =
            Server.defaultConfig
                |> Server.httpPort 3000
        }

type Route
    = Home
    | Increment
    | Count
    | Slow
    | BadMethod
    | Missing

route : Total Route
route =
    oneOf
        [ map Home (get top)
        , map Increment (post (s "increment"))
        , map Count (get (s "count"))
        , map Slow (get (s "slow"))
        ]
        |> methodNotAllowed BadMethod
        |> notFound Missing

handle : Request -> Response
handle req =
    case Route.parse route req of
        Home ->
            Server.html 200 [] (page (countOf req))

        Increment ->
            let
                _ =
                    Process.send Counter.subject Counter.Increment
            in
            Server.empty 204 []

        Count ->
            Server.string 200 [] "text/plain" (String.fromInt (countOf req))

        Slow ->
            let
                _ =
                    Process.sleep 300
            in
            Server.empty 204 []

        BadMethod ->
            Server.empty 405 []

        Missing ->
            Server.empty 404 []

countOf : Request -> Int
countOf _ =
    Process.call Counter.subject 5000 (\reply -> Counter.Get reply)
```

Selm is a rust compiler for elm flavored syntax that compiles into JavaScript for the browser and beam code for the backend. In this example it's doing some process stuff to keep track of the count in memory.

## The Differences

It is a similar syntax to elm, there's only a few differences in the language itself. Most of these are around rough edges I missed from elixir pattern matching when using elm:

1. You can have multiple matches in a case. In elm this would be invalid, you can only match one at a time.
```selm
case status of
  Pending | Loading ->
    "wait"

  Ready | Failed ->
    "go"
```

2. cases can have guards

```selm
size : Maybe Int -> String
size value =
    case value of
        Just n if n > 10 ->
            "large"
        Just _ ->
            "small"
        Nothing ->
            "none"
```

3. Record and tuple patterns can match field values directly

```selm
case user of
  { age = 18, active = True, name } ->
    name

  { name } ->
    name
```

4. there's binary pattern matching
```selm
case input of
  << "PNG", version:8, len:16-little, payload:bytes-size(len), rest:bytes >> ->
    "png v" ++ String.fromInt version

  << flag:1, level:7 >> ->
    "flags"

  _ ->
    "unknown"
```

## What else can you do

There are a lot of things in the [documentation](https://selm.nathanjohnson320.workers.dev/docs/) but the examples are in the source itself which I don't know if I'll ever share. This is the full list of things it supports:

#### Three targets
* JavaScript: browser SPAs (Elm 0.19-compatible hard stack)
* Erlang/BEAM: HTTP servers, DB, websockets, HTML SSR, OTP
* AtomVM: microcontrollers (Device, flash/watch)

#### Language (beyond Elm)
* TEA (Model / Msg / init / update / subscriptions / view)
* OR-patterns, pattern guards, nested record/tuple patterns
* Binary patterns (<< … >>)
* := resource/transaction bindings (BEAM)
* database module, migration module, channel module, job module
* Erlang / Elixir FFI (erlang "mod" "fun", elixir "Mod" "fun")

#### HTTP + OTP (BEAM)
* Server.application / Server.serve / Server.serveWithSupervisor
* Per-request processes; pure handle : Request -> Response
* Routing (Server.Route, Url / Url.Parser / Url.Builder)
* JSON, HTML SSR, static files, CORS, cookies, TLS
* Middleware (Server.Middleware)
* Supervisor / Supervision, Actor, Process (listen / call / send / reply)
* Distributed nodes: Node, Erpc, named subjects
* Outbound HTTP: Req
* Streaming uploads: StreamUpload, Multipart, Stream
* Database + cache
* SQL: Postgres and SQLite via database module + Repo
* Tables, row security (Database.Security), indexes, sequences, typed columns (ints/uints/floats/uuid/json)
* Query pipeline (access -> map -> select / selectAll) inside Repo.transaction
* Migrations: ordered plans + live schema reconcile (no ad-hoc SQL in queries)
* Cache: ETS and Valkey behind the same Cache API on named Repos
* Changeset / Changeset.Validate

#### Realtime
* Typed websocket channels (Channel + Socket)
* Derived codecs for join / up / down
* PubSub + Channel.broadcast

#### Auth + identity
* Password (Argon2id; PBKDF2 verify)
* Jwt (HS256 + RS256)
* Auth.Session, Auth.Csrf, Auth.PasswordReset, Auth.RateLimit, Auth.OAuth
* Cookies

#### Email + content
* Email (SMTP or HTTP webhook), verification tokens
* Email.Mjml (+ attributes)
OpenGraph, Rss, Csv
Html / Html.Document / attributes (SSR); Server.page + JS hydrate

#### Jobs + ops
* Durable Jobs + job module (enqueue, retries, cron; SQLite-backed in the example)
* Logger, OpenTelemetry, Env / Env.Decode
* File, Path, Bytes (+ encode/decode), Base64, Hash, Bitwise
* Time / Time.Format, Duration, Random, Parser / Parser.Advanced

#### AI protocols
* In-app: Mcp, Acp, Port (stdio)
* Tooling: selm-mcp, selm-acp, selm check --json, agent coding guide
* Browser / JS hard stack (built-in, no dep)
* selm/core, html, svg, browser, http, json, url, time, random, bytes, file, parser, virtual-dom. Same shape as Elm 0.19.3. Community Elm packages still come from the registry.

#### CLI / packaging / DX
* init, gen database / gen migration, check, deps, format, make, run, serve, dev (hot reload), console, release, export (static site), docs / docs-gen, test, publish, Mix-style CLI.* tasks
* Hex packages + local path packages; OTP releases; LSP (VS Code/Cursor + Spacemacs)

So if you're interested in trying it feel free to reach out. Again I doubt I'll ever open source the thing but maybe someday.