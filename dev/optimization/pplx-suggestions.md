Here's the audit reworked as a clean, ordered prompt you can paste directly into Antigravity (or any coding agent):

***

```
You are improving the GEO (Generative Engine Optimization) readiness of the static site at https://ikashnitsky.phd. Work through the tasks below in order. Commit after each logical group.

---

## PRIORITY 1 — Unblock AI crawlers (robots.txt)

Add explicit `Allow` rules for all major AI bots to `robots.txt`. Append:

```
User-agent: GPTBot
Allow: /

User-agent: OAI-SearchBot
Allow: /

User-agent: ChatGPT-User
Allow: /

User-agent: anthropic-ai
Allow: /

User-agent: ClaudeBot
Allow: /

User-agent: Claude-SearchBot
Allow: /

User-agent: PerplexityBot
Allow: /

User-agent: Perplexity-User
Allow: /

User-agent: Google-Extended
Allow: /

User-agent: Google-CloudVertexBot
Allow: /

User-agent: Bingbot
Allow: /

User-agent: cohere-ai
Allow: /

User-agent: DuckAssistBot
Allow: /

User-agent: meta-externalagent
Allow: /

User-agent: AI2Bot
Allow: /

User-agent: xAI-Bot
Allow: /

User-agent: YouBot
Allow: /
```

---

## PRIORITY 2 — Create /llms.txt

Create a `/llms.txt` file at the site root. It should include:
- Site name: "demographeR's notes – Ilya Kashnitsky"
- Author: Ilya Kashnitsky, demographer and data visualization researcher
- Purpose: personal research blog on demography, R, and data visualization
- Links to: homepage, about page, key posts/categories, RSS feed

---

## PRIORITY 3 — Add meta description to homepage

Add a `<meta name="description">` tag to the `<head>` of the homepage. Target 150–160 characters. Something like:
> "demographeR's notes — Ilya Kashnitsky's blog on demography, R programming, and data visualization. Research, tutorials, and open science."

Also add `<link rel="canonical" href="https://ikashnitsky.phd/">` to the homepage `<head>`.

---

## PRIORITY 4 — Add JSON-LD structured data to homepage

Inject the following JSON-LD blocks into the homepage `<head>`:

**WebSite schema** (with SearchAction):
```json
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "demographeR's notes",
  "url": "https://ikashnitsky.phd",
  "potentialAction": {
    "@type": "SearchAction",
    "target": "https://ikashnitsky.phd/?s={search_term_string}",
    "query-input": "required name=search_term_string"
  }
}
```

**Person / Organization schema** (with sameAs for Knowledge Graph):
```json
{
  "@context": "https://schema.org",
  "@type": "Person",
  "name": "Ilya Kashnitsky",
  "url": "https://ikashnitsky.phd",
  "sameAs": [
    "https://twitter.com/ikashnitsky",
    "https://github.com/ikashnitsky",
    "https://orcid.org/0000-0003-1835-8687"
  ],
  "jobTitle": "Demographer",
  "contactPoint": {
    "@type": "ContactPoint",
    "contactType": "author inquiry",
    "url": "https://ikashnitsky.phd/about"
  }
}
```
Fill in the correct sameAs URLs from the actual author profiles. Add Wikipedia/Wikidata URLs if available.

---

## PRIORITY 5 — Create AI discovery endpoints

Create the following static JSON files:

**`/.well-known/ai.txt`** — plain text, declaring crawler permissions (mirrors robots.txt AI section).

**`/ai/summary.json`**:
```json
{
  "name": "demographeR's notes",
  "description": "Personal research blog by Ilya Kashnitsky covering demography, R programming, and scientific data visualization.",
  "url": "https://ikashnitsky.phd",
  "author": "Ilya Kashnitsky",
  "language": "en",
  "feed": "https://ikashnitsky.phd/feed"
}
```

**`/ai/faq.json`** — create 5–8 realistic FAQ entries about the site (who is Ilya Kashnitsky, what topics are covered, how to cite, etc.).

**`/ai/service.json`** — describe the site as a research/educational resource.

---

## PRIORITY 6 — Add/improve About page

Ensure there is a visible `/about` page linked from the main navigation. It should include:
- Full name and affiliation
- Research focus (demography, data visualization)
- Contact information or contact form
- Links to profiles (GitHub, ORCID, Twitter/X, Google Scholar)

---

## PRIORITY 7 — Add dateModified signal

For each post/page, inject `<meta property="article:modified_time" content="YYYY-MM-DDTHH:MM:SSZ">` into the `<head>`, populated from the post's last-modified date. Also add `dateModified` to the JSON-LD schema of individual posts.

---

## PRIORITY 8 — RAG chunk readiness

For any post with a section longer than 200 words, split it with an additional H2 or H3 subheading. Ensure each major section opens with a 1–2 sentence definition or summary (this improves AI extraction and citability).

---

## Out of scope for this pass
- Content decay / evergreen rewrite (separate task)
- aria-live / ARIA roles for error recovery (separate a11y pass)
- WebMCP toolname attributes (experimental, defer)
```

***

**Why this ordering matters:** Tasks 1–3 unblock crawlers and fix the most penalized signals (robots.txt misconfiguration and missing `llms.txt` are the primary reasons for the 27/100 score). Tasks 4–5 build the structured data and discovery layer that lifts Identity and Technical Trust from their current 1–2/5 floor. Tasks 6–8 address the remaining Trust Stack gaps (About page, contact info, freshness signals) that keep Social Trust at 1/5. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/170279066/4b14cb1a-d455-419b-9359-2af62b2c4233/260429-geo-optimization.md?AWSAccessKeyId=ASIA2F3EMEYEUDWHQESG&Signature=8VO9Ia1MG0BVx0rBsq8uFES7oLA%3D&x-amz-security-token=IQoJb3JpZ2luX2VjECUaCXVzLWVhc3QtMSJHMEUCIGXt%2Bf99IzOHY1st%2FG6A1wn0LSVvJsr9U5czpd7mXN9XAiEAiIytZGocb74uB6Z9x3VGw467%2FhOmh7srklb5IiJzhUYq%2FAQI7v%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARABGgw2OTk3NTMzMDk3MDUiDCSSnGDY73XdUmIGAirQBFUnumSt6nYIkI3feldh%2FTYIhS5RoSg2dQKYFHeI2k3ZO6D7wKMV30s6q1cP4GR21KhV6iL3jF6lAr95VXdaJA7QmhTKcV0EwIwoFmJ%2B2GL7O%2FzoLfNbOG6JK4lzgHACecO0WRK%2FqKYh6MorF%2BrkTnvueQmtqHV3ixZ1BPu3hKsJSIIiImZjnBIVICCTmDGX1nApd7rNPeiipvML6ToXZcuHnMUCepeKuA%2FzMUfTN62ZaCvekKccALKI45vixha10LFGRKfh0mKRaD%2FNDUFKNz7%2FwLo7RDDFxLm889EeGRTWtorVb2vjCK2NyuKQh9LQRFFSl105zGzFTrm8SG7Kz0seFasHU2Bs%2FMrA2OkC1yMmyIhhsvFi7S54ujESE9tj%2BSK4f5vVwYGAEnA%2FvFZaK3TY%2FNdxK3CVSwuRvipeSK3qfUJcaBLIC%2BRrVdcDGFWaBrHvm3W2WcUq8LFTkj3pchURq%2FLzp9WOHahu5apd4ZR7Z1yrAnH%2BW8OmCdpU1UgAri620lZZfaG8jRBlGkU2cRZB65j0JHu4vMvugqr%2FMk%2FZVLTrAp1qmTjgle9LoS23qcKucK9vFQGHlzVCyVBelxcP4anfmxYdnuGk%2BXGenVJryw2xRT0lfkFeWQAqHU6zJqtwm0ccj3wwsZLPBtoFCfub2R%2BkZZdvhhnzeY4Ttr%2BWH8QKudMksfQw%2BCQK%2BnwV68t0mTKOynrczutUpInE6irT6OHWYtOMfcfznreyUQWcqg5Gj5TZvV%2BZOVMM%2F52qfYb5Cs9p5wzF6QGbmEna5KAw%2B5DGzwY6mAF6R0VzlVbFLHfIDGX%2FCYSRSPC0%2Fx%2BkrznRP1r2lM7Pdka4HO7JlzKusE0FVtHFyz1zCjLXOXd%2BV4cRNnjSoK5BFrOh%2BA01OGz%2F0Ada2DCurOVHiAhuokJNZ1Zc4Rk7vQsHZn22GnAOjfVJaSYz8SaH54dfP9JnU%2BI0vLfyV6y0N7eEl0tZh6fc03N%2FZPAuQs0katL96KF5Lg%3D%3D&Expires=1777439159)