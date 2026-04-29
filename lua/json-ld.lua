function Meta(meta)
  -- Only apply to blog posts (which typically have both title and date)
  if meta.title and meta.date then
    -- Extract and escape double quotes for valid JSON
    local title = pandoc.utils.stringify(meta.title):gsub('"', '\\"')
    local description = ""
    if meta.description then
      description = pandoc.utils.stringify(meta.description):gsub('"', '\\"')
    end
    local date_published = pandoc.utils.stringify(meta.date)
    
    local json_ld = string.format([[
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BlogPosting",
  "headline": "%s",
  "description": "%s",
  "datePublished": "%s",
  "author": {
    "@type": "Person",
    "name": "Ilya Kashnitsky",
    "url": "https://ikashnitsky.phd"
  }
}
</script>
]], title, description, date_published)

    -- Inject into header-includes
    if not meta['header-includes'] then
      meta['header-includes'] = pandoc.MetaList{pandoc.RawBlock('html', json_ld)}
    else
      if pandoc.utils.type(meta['header-includes']) ~= 'List' then
        meta['header-includes'] = pandoc.MetaList{meta['header-includes']}
      end
      table.insert(meta['header-includes'], pandoc.RawBlock('html', json_ld))
    end
  end
  return meta
end
