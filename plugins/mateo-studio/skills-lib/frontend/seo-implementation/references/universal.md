# Universal SEO Reference (Framework-Agnostic)

For Nuxt, SvelteKit, Astro, Remix, vanilla HTML, or any other stack.
Use native framework patterns when available — they handle SSR/SSG correctly.

---

## HTML `<head>` — Core Tags

```html
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <!-- Title: 50-60 chars, unique per page -->
  <title>Page Title — Brand Name</title>

  <!-- Meta description: 150-160 chars, unique per page -->
  <meta name="description" content="Description written to earn the click." />

  <!-- Canonical: always absolute URL -->
  <link rel="canonical" href="https://yourdomain.com/page-slug" />

  <!-- Robots (only needed for non-default behavior) -->
  <!-- <meta name="robots" content="noindex, nofollow" /> -->

  <!-- Open Graph -->
  <meta property="og:type" content="website" />
  <meta property="og:url" content="https://yourdomain.com/page-slug" />
  <meta property="og:title" content="Page Title — Brand Name" />
  <meta property="og:description" content="OG description." />
  <meta property="og:image" content="https://yourdomain.com/og-image.jpg" />
  <meta property="og:image:width" content="1200" />
  <meta property="og:image:height" content="630" />
  <meta property="og:image:alt" content="Descriptive alt for the OG image" />
  <meta property="og:site_name" content="Brand Name" />
  <meta property="og:locale" content="en_US" />

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="Page Title — Brand Name" />
  <meta name="twitter:description" content="Twitter description." />
  <meta name="twitter:image" content="https://yourdomain.com/og-image.jpg" />
  <meta name="twitter:site" content="@yourbrand" />

  <!-- Favicon -->
  <link rel="icon" href="/favicon.ico" />
  <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png" />
  <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
  <link rel="manifest" href="/site.webmanifest" />
  <meta name="theme-color" content="#ffffff" />

  <!-- Google Search Console verification (use env var, not hardcoded) -->
  <!-- <meta name="google-site-verification" content="TOKEN_HERE" /> -->

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Organization",
    "name": "Brand Name",
    "url": "https://yourdomain.com"
  }
  </script>
</head>
```

---

## Framework-Specific Patterns

### Nuxt 3

```ts
// nuxt.config.ts — site-wide defaults
export default defineNuxtConfig({
  app: {
    head: {
      titleTemplate: '%s | Brand Name',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      ],
      link: [{ rel: 'icon', href: '/favicon.ico' }],
    },
  },
});
```

```ts
// Per-page in <script setup>
useSeoMeta({
  title: 'Page Title',
  description: 'Page description',
  ogTitle: 'Page Title — Brand Name',
  ogDescription: 'OG description',
  ogImage: 'https://yourdomain.com/og-image.jpg',
  twitterCard: 'summary_large_image',
});

useHead({
  link: [{ rel: 'canonical', href: 'https://yourdomain.com/page-slug' }],
});
```

### SvelteKit

```html
<!-- src/app.html — global defaults -->
<svelte:head>
  <title>%sveltekit.head%</title>
</svelte:head>
```

```svelte
<!-- +page.svelte — per-page -->
<script>
  import { page } from '$app/stores';
</script>

<svelte:head>
  <title>Page Title | Brand Name</title>
  <meta name="description" content="Page description." />
  <link rel="canonical" href="https://yourdomain.com/page-slug" />
  <meta property="og:title" content="Page Title — Brand Name" />
  <meta property="og:description" content="OG description." />
  <meta property="og:image" content="https://yourdomain.com/og.jpg" />
  <meta name="twitter:card" content="summary_large_image" />
</svelte:head>
```

### Astro

```astro
---
// src/layouts/BaseLayout.astro
interface Props {
  title: string;
  description: string;
  canonicalURL?: string;
  ogImage?: string;
}
const { title, description, canonicalURL = Astro.url, ogImage = '/og-default.jpg' } = Astro.props;
---
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>{title} | Brand Name</title>
    <meta name="description" content={description} />
    <link rel="canonical" href={canonicalURL} />
    <meta property="og:title" content={title} />
    <meta property="og:description" content={description} />
    <meta property="og:image" content={new URL(ogImage, Astro.site)} />
    <meta name="twitter:card" content="summary_large_image" />
  </head>
  <body><slot /></body>
</html>
```

### Remix

```tsx
// app/root.tsx — site-wide
export function meta() {
  return [
    { title: 'Brand Name' },
    { name: 'description', content: 'Site description.' },
  ];
}

// app/routes/page.tsx — per-page
export function meta() {
  return [
    { title: 'Page Title | Brand Name' },
    { name: 'description', content: 'Page description.' },
    { property: 'og:title', content: 'Page Title — Brand Name' },
    { property: 'og:image', content: 'https://yourdomain.com/og.jpg' },
    { tagName: 'link', rel: 'canonical', href: 'https://yourdomain.com/page-slug' },
  ];
}
```

---

## robots.txt (static file in /public)

```
User-agent: *
Allow: /
Disallow: /api/
Disallow: /admin/
Disallow: /private/

# Allow Googlebot specifically (redundant but explicit)
User-agent: Googlebot
Allow: /

Sitemap: https://yourdomain.com/sitemap.xml
```

---

## sitemap.xml (static, or generated at build time)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:image="http://www.google.com/schemas/sitemap-image/1.1">
  <url>
    <loc>https://yourdomain.com/</loc>
    <lastmod>2026-01-01</lastmod>
    <changefreq>monthly</changefreq>
    <priority>1.0</priority>
    <image:image>
      <image:loc>https://cdn.example.com/hero.jpg</image:loc>
      <image:title>Homepage hero image</image:title>
    </image:image>
  </url>
  <url>
    <loc>https://yourdomain.com/about</loc>
    <lastmod>2026-01-01</lastmod>
    <changefreq>yearly</changefreq>
    <priority>0.8</priority>
  </url>
</urlset>
```

---

## site.webmanifest

```json
{
  "name": "Brand Name",
  "short_name": "Brand",
  "description": "Short description of the site/app",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#000000",
  "icons": [
    {
      "src": "/android-chrome-192x192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "/android-chrome-512x512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "any maskable"
    }
  ]
}
```

---

## Performance — Image Optimization Cheat Sheet

| Scenario | Recommendation |
|----------|---------------|
| Hero / above-fold image | `<img fetchpriority="high" loading="eager">` |
| Below-fold images | `<img loading="lazy">` |
| Format | WebP for photos, SVG for logos/icons |
| Always include | `width` and `height` attributes to prevent CLS |
| Responsive | `srcset` + `sizes` for different viewport widths |
| Preconnect CDN | `<link rel="preconnect" href="https://cdn.example.com">` |
