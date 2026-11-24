--[[
SEO / GEO head tags for ikashnitsky.phd

For every rendered page (except 404) this filter injects into <head>:
  * <link rel="canonical"> and og:url   (clean URLs: /2024/slug/ rather than /2024/slug/index.html)
  * og:type (+ article:* tags for blog posts)
  * <meta name="description">           (front-matter `description` / `description-meta`,
                                          otherwise auto-derived from the first paragraphs)
  * JSON-LD structured data:
      - blog posts   -> BlogPosting
      - home page    -> WebSite + Blog + Person + FAQPage (FAQ read from ai/faq.json)
      - me.qmd       -> ProfilePage (Person)

Open Graph / Twitter descriptions are produced by Quarto itself: with no site-wide
`website.description`, Quarto falls back to the first paragraph of each page.
]]

local SITE = "https://ikashnitsky.phd"
local BLOG_NAME = "demographeR's notes"
local DESC_MAX = 160

local PERSON_ID = SITE .. "/#person"
local PERSON = {
  ["@type"] = "Person",
  ["@id"] = PERSON_ID,
  name = "Ilya Kashnitsky",
  url = SITE .. "/me.html",
  image = SITE .. "/img/ik.png",
  jobTitle = "Senior Researcher",
  description = "Demographer working on regional variations in ageing, mortality, population geography, and data visualization.",
  knowsAbout = { "Demography", "Population geography", "Mortality", "Population ageing",
                 "Data visualization", "R programming", "Spatial analysis" },
  worksFor = { ["@type"] = "Organization", name = "Statistics Denmark", url = "https://www.dst.dk/en/" },
  affiliation = {
    ["@type"] = "Organization",
    name = "Leverhulme Centre for Demographic Science, University of Oxford",
    url = "https://www.demography.ox.ac.uk/"
  },
  alumniOf = {
    { ["@type"] = "CollegeOrUniversity", name = "University of Groningen" },
    { ["@type"] = "CollegeOrUniversity", name = "National Research University Higher School of Economics" },
    { ["@type"] = "CollegeOrUniversity", name = "Lomonosov Moscow State University" }
  },
  sameAs = {
    "https://orcid.org/0000-0003-1835-8687",
    "https://scholar.google.com/citations?user=tSQW1XYAAAAJ",
    "https://www.wikidata.org/wiki/Q130311699",
    "https://github.com/ikashnitsky",
    "https://www.linkedin.com/in/ikashnitsky",
    "https://bsky.app/profile/ikashnitsky.phd",
    "https://fosstodon.org/@ikashnitsky"
  }
}
local PERSON_REF = { ["@id"] = PERSON_ID }
local AUTHOR = {
  ["@type"] = "Person",
  ["@id"] = PERSON_ID,
  name = PERSON.name,
  url = PERSON.url,
  sameAs = { "https://orcid.org/0000-0003-1835-8687" }
}

-- ---------------------------------------------------------------------------
-- helpers
-- ---------------------------------------------------------------------------

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local s = f:read("a")
  f:close()
  return s
end

local function html_attr(s)
  return (s:gsub("&", "&amp;"):gsub('"', "&quot;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function squish(s)
  return (s:gsub("%s+", " "):gsub("^ ", ""):gsub(" $", ""))
end

-- truncate to <= n bytes at a word boundary, appending an ellipsis
local function truncate(s, n)
  if #s <= n then return s end
  local cut = s:sub(1, n - 3)
  cut = cut:gsub("%s+%S*$", "")
  cut = cut:gsub("[%s%p]+$", "")
  return cut .. "…"
end

local function meta_str(meta, key)
  local v = meta[key]
  if v == nil then return nil end
  local s = squish(pandoc.utils.stringify(v))
  if s == "" then return nil end
  return s
end

-- raw front matter of the source file (Quarto has already reformatted `date`)
local function front_matter(path)
  local src = read_file(path)
  if not src then return "" end
  return src:match("^%-%-%-\r?\n(.-)\r?\n%-%-%-") or ""
end

local function fm_date(fm, key)
  return fm:match("\n" .. key .. ":%s*[\"']?(%d%d%d%d%-%d%d%-%d%d)")
      or fm:match("^" .. key .. ":%s*[\"']?(%d%d%d%d%-%d%d%-%d%d)")
end

-- plain text of a block, without footnotes, citations, images, raw HTML, shortcodes
local function plain_text(block)
  local cleaned = pandoc.walk_block(block, {
    Note = function() return {} end,
    Cite = function() return {} end,
    Image = function() return {} end,
    RawInline = function() return {} end,
    Span = function(el)
      if el.classes:includes("quarto-shortcode__") then return {} end
    end
  })
  return squish(pandoc.utils.stringify(cleaned))
end

-- first top-level paragraphs, collected until there is enough text for a snippet
local function auto_description(blocks)
  local parts, len = {}, 0
  for _, b in ipairs(blocks) do
    if b.t == "Header" and len > 0 then break end
    if b.t == "Para" then
      local s = plain_text(b)
      if s:match("%a") and #s > 20 then
        table.insert(parts, s)
        len = len + #s
        if len >= 120 then break end
      end
    end
  end
  if #parts == 0 then return nil end
  return truncate(table.concat(parts, " "), DESC_MAX)
end

local function abs_url(rel_dir, path)
  if path:match("^https?://") then return path end
  if path:sub(1, 1) == "/" then return SITE .. path end
  if rel_dir == "" then return SITE .. "/" .. path end
  return SITE .. "/" .. rel_dir .. "/" .. path
end

local function json_ld(obj)
  -- "</" must not appear inside a <script> element
  local s = pandoc.json.encode(obj):gsub("</", "<\\/")
  return '<script type="application/ld+json">' .. s .. "</script>"
end

-- ---------------------------------------------------------------------------
-- main
-- ---------------------------------------------------------------------------

function Pandoc(doc)
  if not quarto.doc.is_format("html") then return nil end

  local meta = doc.meta
  local projdir = quarto.project.directory
  local input = quarto.doc.input_file
  if not projdir or not input then return nil end

  local rel = input:sub(#projdir + 2):gsub("\\", "/")
  if rel == "404.qmd" then return nil end

  local rel_dir = rel:match("^(.*)/[^/]+$") or ""
  local fname = rel:match("([^/]+)$")
  local is_index = fname:match("^index%.[qR]?md$") ~= nil

  local url
  if rel_dir == "" and is_index then
    url = SITE .. "/"
  elseif is_index then
    url = SITE .. "/" .. rel_dir .. "/"
  else
    url = SITE .. "/" .. rel:gsub("%.[qR]?md$", ".html")
  end

  local fm = front_matter(input)
  local is_post = rel:match("^%d%d%d%d/") ~= nil and fm_date(fm, "date") ~= nil
  local is_home = rel == "index.qmd"
  local is_profile = rel == "me.qmd"

  -- description ---------------------------------------------------------------
  local description = meta_str(meta, "description-meta")
      or meta_str(meta, "description")
  if not description then
    description = auto_description(doc.blocks)
    if description then
      meta["description-meta"] = pandoc.MetaString(description)
    end
  end

  -- head tags -----------------------------------------------------------------
  local head = {}
  local function add(s) table.insert(head, s) end

  add(string.format('<link rel="canonical" href="%s">', html_attr(url)))
  add(string.format('<meta property="og:url" content="%s">', html_attr(url)))

  local title = meta_str(meta, "pagetitle") or meta_str(meta, "title") or BLOG_NAME
  local image = meta_str(meta, "image")
  local image_url = image and abs_url(rel_dir, image) or (SITE .. "/img/card-tw.png")

  if is_post then
    local published = fm_date(fm, "date")
    -- only an explicit `date-modified` counts (git dates mostly reflect bulk re-renders)
    local modified = fm_date(fm, "date%-modified")
    if modified and modified <= published then modified = nil end

    local keywords = {}
    if meta.categories then
      for _, c in ipairs(meta.categories) do
        table.insert(keywords, pandoc.utils.stringify(c))
      end
    end

    add('<meta property="og:type" content="article">')
    add(string.format('<meta property="article:published_time" content="%s">', published))
    if modified then
      add(string.format('<meta property="article:modified_time" content="%s">', modified))
    end
    add(string.format('<meta property="article:author" content="%s">', PERSON.url))
    for _, k in ipairs(keywords) do
      add(string.format('<meta property="article:tag" content="%s">', html_attr(k)))
    end

    local posting = {
      ["@context"] = "https://schema.org",
      ["@type"] = "BlogPosting",
      headline = title,
      url = url,
      mainEntityOfPage = { ["@type"] = "WebPage", ["@id"] = url },
      image = image_url,
      datePublished = published,
      dateModified = modified or published,
      inLanguage = "en",
      author = AUTHOR,
      publisher = PERSON_REF,
      isPartOf = { ["@type"] = "Blog", ["@id"] = SITE .. "/#blog", name = BLOG_NAME, url = SITE .. "/" },
      license = "https://creativecommons.org/licenses/by-sa/4.0/"
    }
    if description then posting.description = description end
    if #keywords > 0 then posting.keywords = keywords end
    add(json_ld(posting))

  elseif is_home then
    add('<meta property="og:type" content="website">')
    local graph = {
      {
        ["@type"] = "WebSite",
        ["@id"] = SITE .. "/#website",
        name = BLOG_NAME,
        alternateName = "Ilya Kashnitsky",
        url = SITE .. "/",
        inLanguage = "en",
        publisher = PERSON_REF
      },
      {
        ["@type"] = "Blog",
        ["@id"] = SITE .. "/#blog",
        name = BLOG_NAME,
        url = SITE .. "/",
        description = description,
        author = PERSON_REF,
        inLanguage = "en",
        license = "https://creativecommons.org/licenses/by-sa/4.0/"
      },
      PERSON
    }
    -- FAQ: single source of truth is ai/faq.json
    local faq_src = read_file(projdir .. "/ai/faq.json")
    local ok, faq = pcall(function() return faq_src and pandoc.json.decode(faq_src, false) end)
    if ok and type(faq) == "table" and #faq > 0 then
      local qs = {}
      for _, item in ipairs(faq) do
        if item.question and item.answer then
          table.insert(qs, {
            ["@type"] = "Question",
            name = item.question,
            acceptedAnswer = { ["@type"] = "Answer", text = item.answer }
          })
        end
      end
      if #qs > 0 then
        table.insert(graph, { ["@type"] = "FAQPage", ["@id"] = SITE .. "/#faq", mainEntity = qs })
      end
    end
    add(json_ld({ ["@context"] = "https://schema.org", ["@graph"] = graph }))

  elseif is_profile then
    add('<meta property="og:type" content="profile">')
    add('<meta property="profile:first_name" content="Ilya">')
    add('<meta property="profile:last_name" content="Kashnitsky">')
    add(json_ld({
      ["@context"] = "https://schema.org",
      ["@type"] = "ProfilePage",
      url = url,
      name = title,
      mainEntity = PERSON
    }))

  else
    add('<meta property="og:type" content="website">')
  end

  -- inject --------------------------------------------------------------------
  local block = pandoc.RawBlock("html", table.concat(head, "\n"))
  local hi = meta["header-includes"]
  if hi == nil then
    meta["header-includes"] = pandoc.MetaList({ block })
  else
    if pandoc.utils.type(hi) ~= "List" then hi = pandoc.MetaList({ hi }) end
    hi:insert(block)
    meta["header-includes"] = hi
  end

  doc.meta = meta
  return doc
end
