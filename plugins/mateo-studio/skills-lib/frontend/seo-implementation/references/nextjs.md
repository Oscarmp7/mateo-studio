# Next.js SEO Reference (App Router — v13.2+)

## Metadata API

Export `metadata` from `layout.tsx` (site-wide defaults) and from individual `page.tsx`
files (page-specific overrides). Never use `<Head>` from `next/head` in App Router.

### layout.tsx — Root metadata

```tsx
import type { Metadata, Viewport } from "next";

export const metadata: Metadata = {
  metadataBase: new URL("https://yourdomain.com"),  // Required for resolving relative URLs
  title: {
    default: "Brand Name — Main Keyword",
    template: "%s | Brand Name",  // Sub-pages: "Page Title | Brand Name"
  },
  description: "150–160 char description. Unique, written to earn clicks.",
  keywords: ["keyword 1", "keyword 2"],  // Optional, not a major ranking signal
  authors: [{ name: "Brand Name", url: "/" }],
  creator: "Brand Name",
  publisher: "Brand Name",
  formatDetection: { telephone: false, email: false, address: false },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-image-preview": "large",
      "max-snippet": -1,
      "max-video-preview": -1,
    },
  },
  alternates: {
    canonical: "/",  // Relative — resolved against metadataBase
  },
  openGraph: {
    title: "Brand Name — Main Keyword",
    description: "OG description — can differ slightly from meta description",
    url: "/",                         // Relative — resolved against metadataBase
    siteName: "Brand Name",
    images: [
      {
        url: "/opengraph-image",      // Next.js dynamic OG image route
        width: 1200,
        height: 630,
        alt: "Brand Name descriptive alt text",
      },
    ],
    locale: "en_US",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "Brand Name — Main Keyword",
    description: "Twitter description (up to 200 chars)",
    creator: "@twitterhandle",
    site: "@twitterhandle",
    images: ["/opengraph-image"],
  },
  // Google Search Console verification — store token in env var, never hardcode
  ...(process.env.NEXT_PUBLIC_GSC_TOKEN && {
    verification: { google: process.env.NEXT_PUBLIC_GSC_TOKEN },
  }),
  category: "your category",
  manifest: "/site.webmanifest",
  icons: {
    icon: [
      { url: "/favicon.ico" },
      { url: "/favicon-32x32.png", sizes: "32x32", type: "image/png" },
      { url: "/favicon-16x16.png", sizes: "16x16", type: "image/png" },
    ],
    apple: [{ url: "/apple-touch-icon.png", sizes: "180x180" }],
  },
};

// Viewport MUST be a separate export in Next.js 14+
// Do NOT include viewport inside the metadata object — it's deprecated there
export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  themeColor: [
    { media: "(prefers-color-scheme: light)", color: "#ffffff" },
    { media: "(prefers-color-scheme: dark)", color: "#0a0a0a" },
  ],
  colorScheme: "light dark",
};
```

### page.tsx — Per-page metadata

```tsx
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Page Title",  // Renders as "Page Title | Brand Name" via template
  description: "Page-specific description.",
  alternates: {
    canonical: "/page-slug",
  },
  openGraph: {
    title: "Page Title — Brand Name",
    description: "OG description for this specific page.",
    url: "/page-slug",
    images: [{ url: "/specific-image.jpg", width: 1200, height: 630 }],
  },
};
```

### Dynamic metadata (for dynamic routes like `/blog/[slug]`)

```tsx
export async function generateMetadata({ params }): Promise<Metadata> {
  const post = await fetchPost(params.slug);
  return {
    title: post.title,
    description: post.excerpt,
    alternates: { canonical: `/blog/${params.slug}` },
    openGraph: {
      title: post.title,
      images: [{ url: post.coverImage, width: 1200, height: 630 }],
    },
  };
}
```

---

## Dynamic OG Image — `app/opengraph-image.tsx`

Next.js renders this as `/opengraph-image` automatically. No external service needed.

```tsx
import { ImageResponse } from "next/og";

export const alt = "Brand Name — Tagline";
export const size = { width: 1200, height: 630 };
export const contentType = "image/png";

export default function Image() {
  return new ImageResponse(
    (
      <div
        style={{
          background: "linear-gradient(135deg, #0a0a0a 0%, #111827 100%)",
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "column",
          alignItems: "flex-start",
          justifyContent: "flex-end",
          padding: "80px",
        }}
      >
        <p style={{ color: "#b8975a", fontSize: 18, letterSpacing: "0.2em", textTransform: "uppercase", marginBottom: 24 }}>
          Your Tagline
        </p>
        <h1 style={{ color: "#fff", fontSize: 72, fontWeight: 300, lineHeight: 1.1, margin: 0 }}>
          Brand Name
        </h1>
        <p style={{ color: "#9ca3af", fontSize: 24, marginTop: 20 }}>
          yourdomain.com
        </p>
      </div>
    ),
    { ...size }
  );
}
```

---

## robots.ts — `app/robots.ts`

```ts
import type { MetadataRoute } from "next";

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: "*",
        allow: "/",
        disallow: ["/api/", "/_next/", "/admin/"],
      },
    ],
    sitemap: "https://yourdomain.com/sitemap.xml",
  };
}
```

---

## sitemap.ts — `app/sitemap.ts`

```ts
import type { MetadataRoute } from "next";

export default function sitemap(): MetadataRoute.Sitemap {
  return [
    {
      url: "https://yourdomain.com",
      lastModified: new Date("2026-01-01"),  // Use a real date, not new Date()
      changeFrequency: "monthly",
      priority: 1,
      images: [
        "https://cdn.example.com/hero-image.jpg",
      ],
    },
    {
      url: "https://yourdomain.com/about",
      lastModified: new Date("2026-01-01"),
      changeFrequency: "yearly",
      priority: 0.8,
    },
    {
      url: "https://yourdomain.com/services",
      lastModified: new Date("2026-01-01"),
      changeFrequency: "monthly",
      priority: 0.9,
    },
  ];
}
```

For **dynamic routes** (blog posts, product pages), generate entries from your data source:

```ts
export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const posts = await fetchAllPosts();
  return [
    { url: "https://yourdomain.com", priority: 1 },
    ...posts.map((post) => ({
      url: `https://yourdomain.com/blog/${post.slug}`,
      lastModified: new Date(post.updatedAt),
      changeFrequency: "weekly" as const,
      priority: 0.7,
    })),
  ];
}
```

---

## JSON-LD in page.tsx

Add structured data as inline `<script>` tags inside the JSX return.

```tsx
const organizationJsonLd = {
  "@context": "https://schema.org",
  "@type": "Organization",
  "@id": "https://yourdomain.com/#organization",
  name: "Brand Name",
  url: "https://yourdomain.com",
  logo: "https://yourdomain.com/opengraph-image",
  contactPoint: {
    "@type": "ContactPoint",
    telephone: "+1-555-000-0000",
    contactType: "customer service",
  },
  sameAs: ["https://www.instagram.com/yourbrand"],
};

export default function Page() {
  return (
    <main>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(organizationJsonLd).replace(/</g, "\\u003c"),
        }}
      />
      {/* page content */}
    </main>
  );
}
```

---

## Common gotchas in Next.js

- **`metadataBase` is required** for relative URLs in `alternates.canonical`, `openGraph.url`,
  and `openGraph.images.url` to resolve correctly. Without it, Next.js will warn and may
  output incorrect absolute URLs.
- **Separate `viewport` export**: `viewport` inside the `metadata` object was deprecated
  in Next.js 14. Always use `export const viewport: Viewport = {...}` separately.
- **`"use cache"` directive** (Next.js 16+): Pages are dynamic by default. If you add
  `"use cache"`, make sure your metadata generation still runs correctly.
- **Streaming metadata** (Next.js 15.2+): Streaming is automatically disabled for bots,
  so SEO is not affected — but good to know if testing with curl.
