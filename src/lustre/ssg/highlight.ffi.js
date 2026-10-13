import { Ok, Error } from "../../gleam.mjs";

export function try_highlight(code, grammar, toHtml) {
  try {
    return new Ok(toHtml(code, grammar));
  } catch (_error) {
    return new Error(undefined);
  }
}
