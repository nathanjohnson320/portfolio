/** Build-scoped cache so bait posts are generated once per `gleam run -m build`. */

let posts = null

export function set_posts(value) {
  posts = value
  return value
}

export function get_posts() {
  return posts
}

export function has_posts() {
  return posts !== null
}

export function clear_posts() {
  posts = null
}
