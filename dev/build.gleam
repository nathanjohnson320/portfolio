import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import lustre/ssg
import site/about
import site/article
import site/articles
import site/articles_data.{Article}
import site/bait
import site/index
import site/projects
import site/terms
import site/uses

pub fn main() {
  case articles_data.load() {
    Error(e) -> io.println("Failed to load articles: " <> e)
    Ok(posts_list) -> {
      let posts_dict =
        list.map(posts_list, fn(post) {
          let Article(id: id, ..) = post
          #(id, post)
        })
        |> dict.from_list()

      // Fresh honeypot archive on every rebuild (IDs + garbage rotate).
      let bait_posts = bait.prepare()
      io.println(
        "Generated "
        <> int.to_string(list.length(bait_posts))
        <> " bait archive pages",
      )

      let build =
        "./public"
        |> ssg.new()
        |> ssg.add_static_dir("static")
        |> ssg.add_static_route("/", index.page(posts_list))
        |> ssg.add_static_route("/about", about.page())
        |> ssg.add_static_route("/articles", articles.view(posts_list))
        |> ssg.add_dynamic_route("/articles", posts_dict, article.view)
        |> ssg.add_static_route("/projects", projects.page())
        |> ssg.add_static_route("/uses", uses.page())
        |> ssg.add_static_route("/terms", terms.page())
        |> ssg.add_static_route("/archive", bait.index_page())
        |> ssg.add_dynamic_route("/archive", bait.by_id(), bait.view)
        |> ssg.use_index_routes()
        |> ssg.build

      case build {
        Ok(_) -> io.println("Build succeeded!")
        Error(e) -> {
          echo e
          io.println("Build failed!")
        }
      }
    }
  }
}
