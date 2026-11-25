// Post-render SEO fixes (runs after every project render, incremental or full).
//
// 1. sitemap.xml: use the canonical URLs emitted by lua/seo.lua
//    (".../slug/index.html" -> ".../slug/").
// 2. HTML pages: Quarto writes empty og:description / twitter:description when there is
//    no site-wide description; fill them from the page's <meta name="description">
//    (set in front matter or auto-derived from the first paragraphs by lua/seo.lua).

const outDir = Deno.env.get("QUARTO_PROJECT_OUTPUT_DIR") ?? "docs";

async function rewrite(path: string, fn: (s: string) => string) {
  try {
    const before = await Deno.readTextFile(path);
    const after = fn(before);
    if (after !== before) await Deno.writeTextFile(path, after);
  } catch (e) {
    if (!(e instanceof Deno.errors.NotFound)) throw e;
  }
}

// 1. sitemap
await rewrite(`${outDir}/sitemap.xml`, (xml) =>
  xml.replaceAll(/<loc>([^<]*?\/)index\.html<\/loc>/g, "<loc>$1</loc>"));

// 2. social descriptions
const fillDescriptions = (html: string) => {
  const m = html.match(/<meta name="description" content="([^"]*)"/);
  if (!m || m[1] === "") return html;
  return html
    .replace(/(<meta property="og:description" content=")(")/, `$1${m[1]}$2`)
    .replace(/(<meta name="twitter:description" content=")(")/, `$1${m[1]}$2`);
};

async function* htmlFiles(dir: string): AsyncGenerator<string> {
  for await (const entry of Deno.readDir(dir)) {
    const p = `${dir}/${entry.name}`;
    if (entry.isDirectory && entry.name !== "site_libs") yield* htmlFiles(p);
    else if (entry.isFile && entry.name.endsWith(".html")) yield p;
  }
}

const rendered = (Deno.env.get("QUARTO_PROJECT_OUTPUT_FILES") ?? "")
  .split("\n").map((s) => s.trim()).filter((s) => s.endsWith(".html"));
const targets = rendered.length > 0 ? rendered : await Array.fromAsync(htmlFiles(outDir));
for (const file of targets) await rewrite(file, fillDescriptions);
