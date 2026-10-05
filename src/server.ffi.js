import { createServer } from "node:http";
import { readFileSync, existsSync } from "node:fs";
import { extname } from "node:path";

const MIME = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".json": "application/json",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".gif": "image/gif",
  ".webp": "image/webp",
  ".svg": "image/svg+xml",
  ".ico": "image/x-icon",
  ".pdf": "application/pdf",
  ".woff": "font/woff",
  ".woff2": "font/woff2",
};

/**
 * Creates and starts a Node.js HTTP server.
 * Handler receives (method, url) and returns a Promise of [statusCode, body, contentType].
 * Body may be a string or Buffer.
 */
export function create_and_listen(port, handler) {
  const server = createServer((req, res) => {
    const method = req.method ?? "GET";
    const url = req.url ?? "/";

    const sendResponse = (result) => {
      const statusCode = result[0] ?? 200;
      const body = result[1] ?? "";
      const contentType = result[2] || "text/plain; charset=utf-8";
      res.writeHead(statusCode, { "Content-Type": contentType });
      res.end(body ?? "");
    };

    try {
      const result = handler(method, url);
      if (result && typeof result.then === "function") {
        result.then(sendResponse).catch((err) => {
          console.error(err);
          res.writeHead(500);
          res.end("Internal Server Error");
        });
      } else {
        sendResponse(result);
      }
    } catch (err) {
      console.error(err);
      res.writeHead(500);
      res.end("Internal Server Error");
    }
  });

  server.listen(port);

  const shutdown = () => {
    server.close(() => process.exit(0));
  };
  process.on("SIGINT", shutdown);
  process.on("SIGTERM", shutdown);

  return server;
}

/** Read a static file from disk as Buffer with inferred content type. */
export function read_static_file(path) {
  if (!existsSync(path)) {
    return [404, "Not found", "text/plain; charset=utf-8"];
  }
  try {
    const body = readFileSync(path);
    const type = MIME[extname(path).toLowerCase()] || "application/octet-stream";
    return [200, body, type];
  } catch {
    return [500, "Internal Server Error", "text/plain; charset=utf-8"];
  }
}
