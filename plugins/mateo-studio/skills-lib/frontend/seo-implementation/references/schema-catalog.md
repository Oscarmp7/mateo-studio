# JSON-LD Schema Catalog — 2026

All examples use `@context: https://schema.org` and should be sanitized:
`.replace(/</g, "\\u003c")` before injecting as `dangerouslySetInnerHTML` or similar.

---

## LocalBusiness (+ subtypes)

Use for any business with a physical location or defined service area.
Common subtypes: `CleaningService`, `Restaurant`, `MedicalBusiness`, `LegalService`,
`HealthAndBeautyBusiness`, `HomeAndConstructionBusiness`, `ProfessionalService`.

```json
{
  "@context": "https://schema.org",
  "@type": ["LocalBusiness", "CleaningService"],
  "@id": "https://yourdomain.com/#business",
  "name": "Business Name",
  "description": "What the business does.",
  "url": "https://yourdomain.com",
  "telephone": "+1-555-000-0000",
  "email": "contact@yourdomain.com",
  "priceRange": "$$$",
  "image": ["https://yourdomain.com/image1.jpg"],
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "123 Main St",
    "addressLocality": "Miami",
    "addressRegion": "FL",
    "postalCode": "33130",
    "addressCountry": "US"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": 25.7617,
    "longitude": -80.1918
  },
  "areaServed": [
    { "@type": "City", "name": "Miami" },
    { "@type": "Neighborhood", "name": "Brickell" }
  ],
  "openingHoursSpecification": [
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
      "opens": "08:00",
      "closes": "18:00"
    },
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["Saturday"],
      "opens": "09:00",
      "closes": "14:00"
    }
  ],
  "sameAs": [
    "https://www.instagram.com/yourbrand",
    "https://www.facebook.com/yourbrand"
  ],
  "hasOfferCatalog": {
    "@type": "OfferCatalog",
    "name": "Services",
    "itemListElement": [
      {
        "@type": "Offer",
        "itemOffered": {
          "@type": "Service",
          "name": "Service Name",
          "description": "Service description.",
          "url": "https://yourdomain.com/services"
        }
      }
    ]
  }
}
```

---

## Organization

Use for brand identity. Often paired with `LocalBusiness` on homepage.

```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "@id": "https://yourdomain.com/#organization",
  "name": "Brand Name",
  "url": "https://yourdomain.com",
  "logo": "https://yourdomain.com/logo.png",
  "contactPoint": {
    "@type": "ContactPoint",
    "telephone": "+1-555-000-0000",
    "contactType": "customer service",
    "availableLanguage": ["English", "Spanish"],
    "areaServed": "US"
  },
  "sameAs": [
    "https://www.instagram.com/yourbrand",
    "https://twitter.com/yourbrand",
    "https://www.linkedin.com/company/yourbrand"
  ]
}
```

---

## WebSite

Enables sitelinks search box. Use once per site, on the homepage.

```json
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "@id": "https://yourdomain.com/#website",
  "name": "Brand Name",
  "url": "https://yourdomain.com",
  "description": "Site description.",
  "publisher": {
    "@id": "https://yourdomain.com/#organization"
  },
  "potentialAction": {
    "@type": "SearchAction",
    "target": {
      "@type": "EntryPoint",
      "urlTemplate": "https://yourdomain.com/search?q={search_term_string}"
    },
    "query-input": "required name=search_term_string"
  }
}
```

---

## BreadcrumbList

Add to every sub-page. Helps Google understand site structure.

```json
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "https://yourdomain.com"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "Services",
      "item": "https://yourdomain.com/services"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "Window Cleaning",
      "item": "https://yourdomain.com/services/window-cleaning"
    }
  ]
}
```

---

## Product + AggregateRating

Use on product pages for e-commerce. Required for star ratings in SERPs.

```json
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "Product Name",
  "description": "Product description.",
  "image": "https://yourdomain.com/product.jpg",
  "brand": {
    "@type": "Brand",
    "name": "Brand Name"
  },
  "offers": {
    "@type": "Offer",
    "price": "49.99",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock",
    "url": "https://yourdomain.com/products/product-slug"
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "reviewCount": "124",
    "bestRating": "5",
    "worstRating": "1"
  }
}
```

---

## Article / BlogPosting

Use on blog posts, news articles, long-form content.

```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Article Title (max 110 chars)",
  "description": "Article description.",
  "image": "https://yourdomain.com/article-image.jpg",
  "author": {
    "@type": "Person",
    "name": "Author Name",
    "url": "https://yourdomain.com/authors/author-slug"
  },
  "publisher": {
    "@type": "Organization",
    "name": "Brand Name",
    "logo": {
      "@type": "ImageObject",
      "url": "https://yourdomain.com/logo.png"
    }
  },
  "datePublished": "2026-01-15T08:00:00Z",
  "dateModified": "2026-02-01T10:00:00Z",
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "https://yourdomain.com/blog/article-slug"
  }
}
```

---

## Event

```json
{
  "@context": "https://schema.org",
  "@type": "Event",
  "name": "Event Name",
  "description": "Event description.",
  "startDate": "2026-06-15T19:00:00-05:00",
  "endDate": "2026-06-15T22:00:00-05:00",
  "eventStatus": "https://schema.org/EventScheduled",
  "eventAttendanceMode": "https://schema.org/OfflineEventAttendanceMode",
  "location": {
    "@type": "Place",
    "name": "Venue Name",
    "address": {
      "@type": "PostalAddress",
      "streetAddress": "123 Event St",
      "addressLocality": "Miami",
      "addressRegion": "FL",
      "addressCountry": "US"
    }
  },
  "organizer": {
    "@type": "Organization",
    "name": "Brand Name",
    "url": "https://yourdomain.com"
  },
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock",
    "url": "https://yourdomain.com/events/event-slug"
  }
}
```

---

## Person (for About/Team pages)

```json
{
  "@context": "https://schema.org",
  "@type": "Person",
  "name": "Full Name",
  "jobTitle": "Founder & CEO",
  "worksFor": {
    "@type": "Organization",
    "name": "Brand Name",
    "url": "https://yourdomain.com"
  },
  "url": "https://yourdomain.com/about",
  "image": "https://yourdomain.com/ceo-photo.jpg",
  "sameAs": [
    "https://www.linkedin.com/in/person-slug"
  ]
}
```

---

## Deprecated / Restricted Types (2026) — Do NOT Use

| Type | Status | Reason |
|------|--------|--------|
| `FAQPage` | Restricted | Only gov/health sites get rich results |
| `HowTo` | Deprecated | No longer generates rich results |
| `CourseInstance` | Deprecated | Replaced by `Course` without `CourseInstance` |
| `ClaimReview` | Restricted | Only verified fact-checkers |
| `SpecialAnnouncement` | Removed | Post-COVID cleanup |
| `Speakable` | Deprecated | Google Assistant no longer uses it |
