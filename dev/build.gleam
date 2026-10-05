import gleam/dict
import gleam/io
import gleam/list
import lustre/ssg
import site/about
import site/article
import site/articles
import site/articles_data.{Article}
import site/index
import site/projects
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
