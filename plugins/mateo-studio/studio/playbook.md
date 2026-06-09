# Studio Playbook — Estándar compartido del equipo

Este archivo es la fuente única de verdad del studio de diseño/frontend de Mateo.
Lo leen el orquestador (skill `mateo`) y los 6 agentes especialistas. No dupliques
estos estándares en cada agente — apunta aquí.

Conversación con el usuario: español. Código y comentarios técnicos: inglés.

## Cómo resolver las rutas del plugin (léelo primero)

Este playbook y las skills viven DENTRO del plugin `mateo-studio`, cuya ruta de
instalación varía por máquina. Para obtener la raíz absoluta del plugin, ejecuta:

```bash
cat "$HOME/.claude/.mateo-studio-root"
```

Ese archivo lo escribe el hook `SessionStart` del plugin y contiene la ruta absoluta
de instalación (`${CLAUDE_PLUGIN_ROOT}`). Llámala **PLUGIN_ROOT**. En este documento:
- El playbook está en `PLUGIN_ROOT/studio/playbook.md`.
- Las skills vendored están en `PLUGIN_ROOT/skills-lib/` (ver §5).

Si ese archivo no existe (hook no ejecutado), localízalo con:
`find "$HOME/.claude/plugins" -path "*mateo-studio/studio/playbook.md" | head -1`.

---

## 1. El equipo y el flujo

| Fase | Quién | Modelo | Entra | Sale |
|------|-------|--------|-------|------|
| 0 | **mateo** (orquestador, sesión principal) | Opus | brief / URL / imagen | PRODUCT.md + refs |
| 1 | **strategist** (agente) | Opus | PRODUCT.md | spec de estrategia |
| 2 | **ux-architect** (agente) | Sonnet | estrategia | flujos + IA + wireframes |
| 3 | **art-director** (agente) | Opus | UX + refs | design-system/MASTER.md + DESIGN.md |
| 4 | **frontend-architect** (agente) | Sonnet | design system | arquitectura + stack |
| 5 | **sofia** (builder, agente) | Sonnet | arquitectura | código production-ready |
| 6 | **qa-reviewer** (agente) | Opus | código | aprobado / rebote con fixes |

**Gates de aprobación** (los maneja mateo en la sesión principal):
- Tras Fase 2 → aprobar flujos/IA antes de estética.
- Tras Fase 3 → aprobar dirección estética + design system antes de construir. **(el gate más importante)**
- Tras Fase 6 → aprobar entrega.

Un agente especialista **nunca delega ni invoca a otro agente**. Hace su trabajo y
reporta a mateo. Solo mateo (sesión principal) orquesta.

---

## 2. Principios de diseño (no negociables) — el antídoto contra el look-IA

El objetivo central: **que el output NO parezca hecho por IA**. Eso se logra
con disciplina de diseño, no con suerte.

### Lo prohibido (señales de "slop" de IA)
- ❌ NUNCA Inter, Roboto, Arial, Space Grotesk como primera elección tipográfica.
- ❌ NUNCA gradiente morado-sobre-blanco como paleta por defecto.
- ❌ NUNCA 3 columnas simétricas como primer layout.
- ❌ NUNCA emojis como iconos (solo SVG: Heroicons, Lucide, Simple Icons).
- ❌ NUNCA imágenes stock genéricas si se puede generar algo bespoke (usa `nano-banana`).
- ❌ NUNCA copy de relleno tipo "Empower your workflow with cutting-edge solutions".

### Lo obligatorio
- ✅ Una dirección estética clara y ejecutada con precisión. Nunca convergir en lo genérico.
- ✅ Tipografías con carácter (busca en Google Fonts más allá de las default).
- ✅ Paleta dominante con un acento afilado > paletas tímidas equidistribuidas.
- ✅ OKLCH para color (mejor uniformidad perceptual que HSL — CSS Color Module Level 4, W3C).
- ✅ CSS variables / design tokens para consistencia total.
- ✅ **Token-first / zero-hardcode.** Todo valor de diseño (color, spacing, radio, sombra,
  tipografía, duración, z-index, breakpoint) sale de un token — nunca un literal en el
  componente. Modelo: design tokens como *single source of truth* (W3C Design Tokens
  Community Group, spec estable 2025.10). En Tailwind v4 se implementa con `@theme`
  (`--color-*`, `--spacing-*`, `--radius-*`, `--text-*`). Único hardcode permitido: lo que
  las buenas prácticas confirman como no-tokenizable (`0`, `1px` de border, `100%`, resets).
- ✅ **Component-first / DRY.** UI construida bottom-up (Component-Driven Development):
  átomos → moléculas → organismos → vistas (Atomic Design, Brad Frost). Ningún markup se
  repite dos veces sin extraerse a componente. Cada componente es moldeable vía props/
  variantes (CVA). DRY (*Don't Repeat Yourself*) como ley.
- ✅ Jerarquía, contraste y restraint deliberados — el vocabulario de `impeccable`.

### Animación / motion
- Micro-feedback (hover, click): 100–150ms · Toggles/dropdowns: 200–300ms · Páginas/modales: 300–500ms.
- Spring sobre linear cuando aplique. Animar SOLO `transform` y `opacity` (60fps). NUNCA width/height/top/left.
- SIEMPRE respetar `prefers-reduced-motion` — es accesibilidad, no opcional.

### Responsive
- Mobile-first: base sin prefijo, overrides con `sm:`/`md:`/`lg:`. Touch targets ≥ 44×44px. Body text ≥ 16px en móvil.
- Sin scroll horizontal en ningún viewport. Container queries para componentes dependientes del contenedor.

---

## 3. Protocolo de fidelidad visual (clonado + referencia de imagen)

Esto es lo que garantiza "al pie de la letra". El mecanismo es el **visual-diff loop**.

### A. Clonar una web (URL)
1. mateo usa **playwright**: screenshots full-page en 375 / 768 / 1024 / 1440px + extrae DOM/CSS computado (colores, fonts, spacing, sizes). Guarda en `.refs/clone/`.
2. art-director lee los screenshots con `Read` (los VE) + el dump CSS → replica paleta/tipografía/escala exactas en el design system.
3. ux-architect deriva estructura/secciones desde el DOM.
4. sofia reconstruye en el stack elegido.
5. qa-reviewer hace **visual-diff**: screenshot del build vs original → lista diferencias → rebota → repite hasta calcar.

### B. Referencia de imagen (mockup/captura que envía el usuario)
1. mateo (sesión principal) VE la imagen con `Read` y la descompone en spec estructurada: layout/grid, paleta (a OKLCH/hex), tipografía (serif/sans/display, peso, escala), espaciado, inventario de componentes, jerarquía.
2. Guarda la imagen en `.refs/` y pasa **ruta + spec** al art-director (los sub-agentes leen la imagen por ruta, no por el prompt).
3. sofia construye contra la spec.
4. qa-reviewer compara el render vs la imagen original → mide desviaciones → rebota → repite hasta fidelidad.

> Regla de oro: pasar imágenes *crudas* a un sub-agente no es confiable (los prompts entre agentes son texto). mateo VE primero y traduce a spec + ruta en disco.

### C. Origen Figma
Si la referencia es Figma y el MCP `figma` está activo: art-director y sofia leen tokens/auto-layout/variantes reales desde Dev Mode (fidelidad de tokens, no aproximación).

---

## 4. Checklist de producción (lo corre qa-reviewer; no se entrega hasta que pase)

**Fidelidad al brief:** secciones completas · CTAs correctos y funcionales · copy correcto · rutas/navegación OK.

**Visual:** design system aplicado consistente · sin emojis como iconos · logos verificados en Simple Icons · hover sin layout shift · `cursor-pointer` en clickables · transiciones 150–300ms · focus states visibles.

**Responsive (Playwright en cada viewport):** 375 · 768 · 1024 · 1440 · sin scroll horizontal.

**Accesibilidad:** alt text en imágenes · labels en inputs · contraste ≥ 4.5:1 · `prefers-reduced-motion` respetado · orden de tab lógico.

**Anti-IA (slop detector de impeccable):** correr las 41 reglas. Si huele a genérico → rebote.

**Zero-hardcode audit:** grep de valores de diseño literales fuera del design system (hex/rgb
sueltos, px mágicos de spacing/radio, ms de animación, z-index numéricos). Cualquier hallazgo
fuera de las excepciones permitidas (§2 token-first) → rebote a sofia.

**SEO técnico (solo sitios públicos):** title único 50–60 chars · meta description 150–160 · canonical self-referencing en todas · OG image 1200×630 URL absoluta · twitter:card · sitemap.xml · robots.txt no bloquea CSS/JS · JSON-LD pertinente · viewport meta.
- Notas 2026: usar **INP** (no FID, reemplazado mar-2024). NO usar FAQPage/HowTo/SpecialAnnouncement schema.

**Performance:** LCP ≤ 2.5s · CLS ≤ 0.1 · INP ≤ 200ms · imágenes WebP/AVIF + lazy · hero con `fetchpriority="high"` (no lazy) · sin waterfalls (Promise.all) · code splitting en rutas pesadas · build sin errores TS/lint · sin `console.*` en runtime.

---

## 5. Índice de skills (vendored en el plugin) — qué leer y quién lo usa

Raíz: `PLUGIN_ROOT/skills-lib/` (resuelve PLUGIN_ROOT como se explica arriba).
Lee el `SKILL.md` pertinente con `Read` solo cuando lo necesites. No cargues todo.
Ej.: `Read "<PLUGIN_ROOT>/skills-lib/frontend/ui-ux-pro-max/SKILL.md"`.

### frontend/
- `ui-ux-pro-max/` — design system completo (50+ estilos, paletas, scripts) → **art-director**
- `frontend-design/` — UI distintiva, anti-genérica → **art-director**
- `interaction-design/` — microinteracciones, motion, feedback → **art-director / sofia**
- `tailwind-design-system/` — Tailwind v4 CSS-first, tokens, CVA → **art-director / sofia**
- `responsive-design/` — container queries, fluid, breakpoints → **ux-architect / sofia**
- `gsap-core, gsap-timeline, gsap-scrolltrigger, gsap-plugins, gsap-utils, gsap-react, gsap-performance, gsap-frameworks` → **sofia** (en React/Next: `gsap-react` es OBLIGATORIO)
- `nextjs-app-router-patterns/`, `react-state-management/`, `typescript-advanced-types/`, `modern-javascript-patterns/` → **frontend-architect / sofia**
- `seo-implementation/` → **ux-architect / qa-reviewer**
- `nano-banana/` — generar imágenes/assets bespoke → **art-director / sofia**
- `remotion/` — video en React → **sofia** (si hay video)
- `intent/skills/` — `strategize` → **strategist**; `storytelling` → **ux-architect**; `transpose` (copy) → **art-director**

### marketing/  → **strategist** (y `copywriting` → **art-director** para copy UX)
- `copywriting/`, `pricing-strategy/`, `launch-strategy/`, `cold-email/`

### business/  → **strategist**
- `startup-metrics-framework/`, `micro-saas-launcher/`, `inventory-demand-planning/`

### backend/ · database/ · payments/  → **frontend-architect / sofia** (cuando el frontend toca backend)
- `api-design-principles/`, `auth-implementation-patterns/`, `database-migration/`, `microservices-patterns/`
- `postgres-best-practices/`, `postgresql-optimization/`, `prisma-expert/`
- `stripe-best-practices/`, `stripe-integration/`

> **impeccable** (vocabulario de diseño + slop detector de 41 reglas) y **taste-skill**
> (variantes de estilo) son skills externas de alto valor para art-director/qa-reviewer.
> Si están instaladas como plugins/skills aparte, úsalas. Para mantener fidelidad anti-IA
> sin ellas, aplica §2 + §4 de este playbook como sustituto funcional.

---

## 6. MCPs — vienen con el plugin; guía y degradación elegante

Este plugin **declara sus MCPs** en `PLUGIN_ROOT/.mcp.json`, así que se cargan al activar
el plugin (no hay que copiar plantillas por proyecto como antes). Dos grupos:

**Sin credenciales (funcionan solo con Node.js instalado):**
| MCP | Para qué | Quién |
|-----|----------|-------|
| context7 | docs exactas de librerías (versión correcta) | frontend-architect / sofia |
| playwright | clonado, screenshots, visual-diff, responsive, e2e | mateo / art-director / qa-reviewer |
| shadcn / magicui | buscar componentes antes de construir | art-director / sofia |

**Con credenciales (requieren que el usuario ponga su API key como variable de entorno):**
| MCP | Para qué | Variable de entorno |
|-----|----------|---------------------|
| github | repos, branches, PRs | `GITHUB_PERSONAL_ACCESS_TOKEN` |
| magic (21st.dev) | generar componentes UI | `MAGIC_API_KEY` |
| supabase | backend SaaS | `SUPABASE_ACCESS_TOKEN` |
| vercel | estado de deploy + logs | (auth OAuth) |

**Degradación elegante (regla de oro):** si un MCP necesario no está activo o sin key, NO
inventes ni sigas a ciegas. Avisa al usuario: "Falta el MCP `X` o su API key. Configúralo
como dice el INSTALL.md y reinicia la sesión." Esto evita el fallo del Mateo viejo (asumía
MCPs que no existían y degradaba en silencio). El studio funciona sin los MCPs con key; solo
pierde esas capacidades puntuales.

---

## 7. Definición de "production-ready"
1. Build compila sin warnings ni errores · 2. TypeScript strict sin errores ·
3. Lighthouse: Performance >90, A11y >95, SEO >95, Best Practices >90 ·
4. Funciona en Chrome/Firefox/Safari · 5. Responsive en todos los viewports ·
6. Deploy live sin errores · 7. Links/CTAs funcionan · 8. Imágenes optimizadas, sin 404s ·
9. `.mateo/context.md` actualizado ·
10. Sin valores de diseño hardcodeados — todo vía token (verificado en §4 zero-hardcode audit).
