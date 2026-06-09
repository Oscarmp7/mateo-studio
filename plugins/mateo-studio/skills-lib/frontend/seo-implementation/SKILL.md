---
name: seo-implementation
description: >
  Comprehensive SEO audit and implementation for any web framework. Use this skill whenever
  the user asks to improve SEO, add metadata, fix search rankings, implement structured data
  or JSON-LD, optimize Core Web Vitals, set up sitemaps or robots.txt, improve local SEO,
  add Open Graph / Twitter card previews, or anything related to making a site more
  discoverable. Also trigger for "why isn't my site on Google", "how do I rank higher",
  "add schema markup", "fix my meta tags", or "get more organic traffic". Always use this
  skill even if the request seems simple — SEO has many interconnected layers that are easy
  to get wrong without a structured approach.
---

# SEO Implementation

You are implementing SEO for a real site. This is not a checklist to fill mechanically —
it's a layered strategy where each decision should be intentional and based on the site's
actual content, audience, and goals.

## Process

1. **Audit** — Read existing files to understand what's already in place (title tags,
   meta, any existing schema, robots, sitemap). Don't duplicate or break what works.
2. **Detect stack** — Identify the framework and version. Each has native patterns that
   are always preferable to third-party libraries.
3. **Implement layer by layer** — Follow the priority order below. Don't skip ahead.
4. **Verify** — Run the verification checklist before declaring done.

## Stack Detection

Identify before touching anything:
- **Framework**: Next.js (App Router vs Pages Router), Nuxt, Remix, SvelteKit, Astro,
  vanilla HTML, WordPress, etc.
- **Version**: Critical for Next.js — App Router metadata API (v13.2+) is completely
  different from Pages Router `<Head>`.
- **Rendering mode**: SSG, SSR, ISR, CSR, hybrid. Affects how search engines see the page.
- **Existing SEO setup**: What's there, what's missing, what's broken.

Then read the relevant reference file:
- **Next.js 13+ App Router** → `references/nextjs.md`
- **All other frameworks or vanilla** → `references/universal.md`

## SEO Priority Stack

Implement in this order. Each layer builds on the previous.

### Layer 1 — Technical Foundation (required on every site)

**Title**
- Unique per page. 50–60 chars. Format: `Primary Keyword — Brand Name`
- Use a template for sub-pages: `{Page Title} | Brand` — never repeat the full site title
- The title tag is still the single highest-weight on-page signal

**Meta Description**
- 150–160 chars. Unique per page. Written to earn the click, not just describe content.
- Google may rewrite it, but a good description still influences CTR

**Canonical URL**
- Absolute URL on every page. Prevents duplicate content from query strings, trailing
  slashes, http vs https variants
- Self-referencing canonical on every page, even if you think it's unambiguous

**robots.txt**
- Allow all crawlers by default
- Block: `/api/`, `/_next/`, `/admin/`, any internal tooling
- Always reference sitemap URL at the bottom
- Never block CSS or JS — Google needs to render pages

**sitemap.xml**
- All public, indexable URLs
- Include `<image:image>` entries for image-heavy pages (gallery, portfolio)
- Use `lastmod` with a real date, not `new Date()` (which changes on every deploy)
- `changefreq`: homepage = monthly, blog = weekly, contact = yearly

**Open Graph + Twitter Cards**
- `og:title`, `og:description`, `og:image` (1200×630 PNG/JPG), `og:url`, `og:type`
- `twitter:card = summary_large_image`, `twitter:title`, `twitter:description`,
  `twitter:image`
- OG image must be absolute URL. Generates previews on LinkedIn, WhatsApp, iMessage, etc.

**Viewport**
- `width=device-width, initial-scale=1` — required for mobile-first indexing
- In Next.js 14+, use the separate `viewport` export (not inside `metadata`)

### Layer 2 — Structured Data / JSON-LD

Always use `<script type="application/ld+json">` — never microdata or RDFa.
Sanitize output to prevent XSS: `.replace(/</g, "\\u003c")`
Place in `<head>` or `<body>` — Google accepts both.

See `references/schema-catalog.md` for full examples of each type.

**Valid, high-impact types in 2026:**

| Type | Use for |
|------|---------|
| `LocalBusiness` (+ subtype) | Any business with a physical presence |
| `Organization` | Brand identity, sameAs social links |
| `WebSite` | Sitelinks search box, site identity |
| `Product` + `AggregateRating` | E-commerce, product pages |
| `Article` / `BlogPosting` | Content/editorial sites |
| `BreadcrumbList` | Every sub-page (helps search understand site structure) |
| `Event` | Events, concerts, webinars |
| `JobPosting` | Job boards, careers pages |
| `Recipe` | Food blogs |
| `VideoObject` | Pages with embedded video |

**Deprecated or restricted in 2026 — do not use:**
- `FAQPage` — restricted to government and health sites only (was abused, Google removed rich results)
- `HowTo` — no longer generates rich results
- `CourseInstance` — deprecated
- `ClaimReview` — restricted to verified fact-checkers
- `SpecialAnnouncement` — removed post-COVID

**Multiple schemas on one page**: Use an array or separate `<script>` tags per type.
Homepage typically needs: `LocalBusiness/Organization` + `WebSite` (+ `BreadcrumbList` if applicable).

### Layer 3 — E-E-A-T Signals

Google evaluates Experience, Expertise, Authoritativeness, Trustworthiness.
These are not tags — they're signals in the content itself.

**Experience**: Real photos, first-person accounts, case studies, dates, specific details.
A cleaning service showing actual before/after photos > stock images.

**Expertise**: About page with credentials, team bios, CEO/founder section, certifications.
For local businesses: years in operation, specific service areas, named professionals.

**Authoritativeness**: External mentions, press coverage, industry associations, awards.
In schema: `sameAs` links to verified social profiles, Wikipedia, official directories.

**Trustworthiness**: Contact info (phone, email, address) visible and consistent,
privacy policy, SSL, physical address matching Google Business Profile.

**For local businesses specifically:**
- NAP (Name, Address, Phone) must be identical across site and Google Business Profile
- Full address in `LocalBusiness` schema with `geo` coordinates
- `openingHoursSpecification` in schema
- Google Business Profile signals = ~32% of map pack rankings (2026)

### Layer 4 — Core Web Vitals (2026 thresholds)

These are ranking signals. Failing them hurts visibility on mobile especially.

| Metric | Good | Needs Work | Poor |
|--------|------|------------|------|
| **LCP** (Largest Contentful Paint) | ≤ 2.5s | 2.5–4s | > 4s |
| **CLS** (Cumulative Layout Shift) | ≤ 0.1 | 0.1–0.25 | > 0.25 |
| **INP** (Interaction to Next Paint) | ≤ 200ms | 200–500ms | > 500ms |

> Note: INP **replaced FID** (First Input Delay) as a Core Web Vital in March 2024.
> If you see old resources mentioning FID as a ranking signal, they're outdated.

**LCP optimization**:
- Add `priority` / `fetchpriority="high"` to the hero/above-fold image
- Use `sizes` attribute on responsive images
- Serve WebP or AVIF (not JPEG/PNG for photography)
- Preconnect to image CDNs: `<link rel="preconnect" href="https://cdn.example.com">`

**CLS optimization**:
- Always set explicit `width` and `height` on images (or use `aspect-ratio` in CSS)
- Reserve space for ads, embeds, lazy-loaded content
- Don't inject content above existing content on load

**INP optimization**:
- Break up long JavaScript tasks (> 50ms) using `setTimeout` or `scheduler.yield()`
- Defer non-critical scripts
- Avoid synchronous localStorage/sessionStorage reads on interaction

### Layer 5 — Advanced (for sites that need to go further)

**Hreflang** (multilingual sites):
```html
<link rel="alternate" hreflang="en" href="https://example.com/en/" />
<link rel="alternate" hreflang="es" href="https://example.com/es/" />
<link rel="alternate" hreflang="x-default" href="https://example.com/" />
```

**Pagination**: Use `rel="next"` and `rel="prev"` for paginated content.

**Google Search Console verification**: Use `<meta name="google-site-verification">` or
DNS TXT record. Store tokens in environment variables, never hardcode in source.

**PWA / Web App Manifest**: `site.webmanifest` with `name`, `short_name`, `icons`,
`theme_color`, `background_color`, `display: standalone`. Linked via
`<link rel="manifest" href="/site.webmanifest">`.

**AI Overviews (2026)**: ~76% of AI Overview citations come from top-10 organic results.
The best strategy: rank organically. There is no special "AI Overview optimization" beyond
strong E-E-A-T and structured data.

**llms.txt**: Proposed standard for AI crawler guidance. As of early 2026, major AI
crawlers (GPTBot, ClaudeBot, Google-Extended) don't actually follow it. Don't prioritize
over real SEO work.

## What NOT to do

- **`keywords` meta tag**: Ignored by Google since 2009. Don't waste time on it.
- **Duplicate canonical URLs**: Each page needs its own canonical.
- **`noindex` in production**: Double-check robots meta tags before deploying.
- **Block CSS/JS in robots.txt**: Prevents Google from rendering. Always allow.
- **Absolute URLs where relative would be resolved** (e.g., Next.js with `metadataBase`)
- **Hardcoded API keys or tokens** in meta verification tags
- **Multiple H1 tags**: One H1 per page, hierarchy H1 → H2 → H3
- **Thin content pages**: Pages with < 300 words of unique content shouldn't be indexed

## Verification Checklist

After implementing, verify before calling it done:

- [ ] Build passes clean (no TypeScript/lint errors)
- [ ] `/robots.txt` — renders with correct allow/disallow rules
- [ ] `/sitemap.xml` — all public pages listed, images included where relevant
- [ ] OG image endpoint (if dynamic) — renders correct branded image
- [ ] **Rich Results Test** at search.google.com/test/rich-results — validates JSON-LD
- [ ] **PageSpeed Insights** — Core Web Vitals pass (especially LCP and CLS)
- [ ] Social preview: paste URL into LinkedIn/WhatsApp developer tools to verify OG
- [ ] Canonical tags: check source of a few pages to confirm they're correct
- [ ] No accidental `noindex` in production headers or meta tags

## Reference Files

- `references/nextjs.md` — Next.js 13+ App Router: metadata API, viewport, robots.ts,
  sitemap.ts, dynamic OG images with next/og
- `references/universal.md` — Framework-agnostic: HTML head patterns, static
  robots.txt/sitemap.xml, JSON-LD in any template
- `references/schema-catalog.md` — Full JSON-LD code examples for every schema type
