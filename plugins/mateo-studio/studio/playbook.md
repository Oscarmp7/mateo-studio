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
| 2 | **ux-architect** (agente) | Opus | estrategia | flujos + IA + wireframes |
| 3 | **art-director** (agente) | Opus | UX + refs | design-system/MASTER.md + DESIGN.md |
| 4 | **frontend-architect** (agente) | Opus | design system | arquitectura + stack |
| 5 | **sofia** (builder, agente) | Opus | arquitectura | código production-ready |
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

**Regla anti-silencio (para TODOS los agentes):** si un SKILL.md, plugin o recurso
referenciado NO existe en esta máquina, decláralo en tu reporte final a mateo — nunca
lo omitas en silencio. Mateo acumula los faltantes y los presenta al usuario.

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

**Degradación elegante (aplica a MCPs, skills Y plugins):** degradar está permitido SOLO
si es visible y decidido por el usuario; **degradar en silencio es un bug del studio**. Si
un recurso necesario no está disponible: (1) mateo lo lista en el preflight de Fase 0 con
su impacto, (2) ofrece arreglarlo con el comando **`/mateo-init`** (verifica Node, MCPs
cargados, keys de entorno, skills-lib del plugin — e instala/configura lo posible; MCPs y
plugins cargan al inicio de sesión: tras configurar hay que reiniciar), (3) si el usuario
decide seguir sin él, queda anotado en `.mateo/context.md`. Esto evita el fallo del Mateo
viejo (asumía MCPs que no existían y degradaba en silencio).

---

## 7. Definición de "production-ready"
1. Build compila sin warnings ni errores · 2. TypeScript strict sin errores ·
3. Lighthouse: Performance >90, A11y >95, SEO >95, Best Practices >90 ·
4. Funciona en Chrome/Firefox/Safari · 5. Responsive en todos los viewports ·
6. Deploy live sin errores · 7. Links/CTAs funcionan · 8. Imágenes optimizadas, sin 404s ·
9. `.mateo/context.md` actualizado ·
10. Sin valores de diseño hardcodeados — todo vía token (verificado en §4 zero-hardcode audit).
11. Esqueleto canónico (§8) respetado y código comentado/seccionado según §8.

---

## 8. Estructura canónica de proyectos (obligatoria, agnóstica de tecnología)

**Objetivo:** que TODO proyecto del studio — sin importar el stack — tenga la misma
estructuración, navegable de la misma forma. El frontend-architect la aplica al definir
la arquitectura (Fase 4); sofia la respeta al construir (Fase 5); qa-reviewer la audita
(Fase 6).

### 8.1 Esqueleto base

```
<raíz del proyecto>
├── README.md                   # setup en ≤3 comandos + stack + scripts
├── PRODUCT.md                  # qué es, para quién (Fase 0)
├── DESIGN.md                   # dirección estética aprobada (Fase 3)
├── design-system/MASTER.md     # tokens, paleta, tipografía (Fase 3)
├── docs/
│   ├── ARCHITECTURE.md         # mapa del proyecto: qué vive dónde y por qué (Fase 4)
│   └── adr/                    # Architecture Decision Records: NNNN-titulo.md
├── public/                     # assets estáticos (optimizados, sin originales pesados)
├── .env.example                # TODAS las vars documentadas, sin valores reales
├── .refs/                      # referencias visuales (clones, mockups)
├── .mateo/context.md           # memoria del proyecto
└── src/
    ├── app/                    # capa de rutas (ver mapeo 8.2)
    ├── components/
    │   ├── ui/                 # átomos: Button, Input, Card, Badge...
    │   ├── layout/             # Navbar, Footer, Sidebar, Shell
    │   └── sections/           # organismos por dominio: Hero, Pricing, FAQ...
    ├── hooks/                  # custom hooks / composables
    ├── lib/                    # utils (cn()), helpers, clients de API, constantes
    ├── styles/                 # tokens (@theme), globals.css
    └── types/                  # tipos/interfaces compartidos
```

Reglas: un componente = un archivo (PascalCase). Nada vive "suelto" en `src/` — todo
archivo pertenece a una de estas carpetas. Si una carpeta queda vacía, no se crea.
Lo específico de un solo feature grande puede agruparse en `src/features/<nombre>/`
replicando internamente el mismo patrón (components/, hooks/, lib/).

### 8.2 Mapeo por plataforma (misma lógica, nombres del framework)

| Plataforma | Capa de rutas | Resto |
|------------|---------------|-------|
| Next.js (App Router) | `src/app/` (pages, layouts, route handlers) | idéntico al esqueleto |
| Astro | `src/pages/` + `src/layouts/` | idéntico al esqueleto |
| Vite/SPA React | `src/routes/` (router elegido) | idéntico al esqueleto |
| React Native / Expo | `app/` (expo-router) en raíz | `src/` con el resto del esqueleto |
| Tauri | frontend en `src/` (esqueleto completo) | nativo en `src-tauri/` (no se toca el patrón) |

El frontend-architect declara este mapeo explícitamente en su entregable. Cualquier
desviación necesaria (convención dura del framework) se documenta en `.mateo/context.md`.

### 8.3 Comentado y seccionado del código (lo aplica sofia)

El código debe poder leerse como un documento: comentado y seccionado, en inglés.

- **Header de archivo** (2–3 líneas) en todo archivo no trivial: qué es y dónde encaja.
  ```tsx
  /**
   * Hero — landing hero section with headline, CTA and product visual.
   * Used in: app/page.tsx. Tokens: design-system/MASTER.md.
   */
  ```
- **Separadores de sección** en archivos largos (>~80 líneas), en orden fijo:
  types → constants → helpers → subcomponents → main component/export.
  ```tsx
  /* ──────────────── Types ──────────────── */
  /* ──────────────── Helpers ──────────────── */
  /* ──────────────── Component ──────────────── */
  ```
- **JSDoc en todo lo exportado** (componentes, hooks, utils): una línea de propósito;
  props/params solo cuando no son obvios.
- **Comentarios de "por qué", no de "qué"**: se comenta la decisión o el edge case,
  no la línea evidente. Sin comentarios-ruido línea por línea.
- En CSS/tokens: cada bloque de `@theme` agrupado y titulado (colors / spacing /
  typography / motion).

### 8.4 Estándar de ingeniería (nivel élite — Google/Vercel/Airbnb style guides)

Profesional ≠ complejo: estas reglas elevan la calidad SIN añadir capas que el proyecto
no pide. Se aplican siempre, en cualquier stack.

**Naming (consistencia absoluta):**
- Componentes y sus archivos: `PascalCase` (`HeroSection.tsx`). Hooks: `useThing.ts`.
  Utils/lib: `camelCase.ts`. Carpetas: `kebab-case` o lowercase.
- Constantes: `UPPER_SNAKE_CASE`. Tipos/interfaces: `PascalCase` sin prefijo `I`.
- Nombres que dicen QUÉ es, no cómo está hecho (`PricingTable`, no `ThreeColGrid`).
- Booleans con prefijo `is/has/can/should`; handlers `handleX`; props de evento `onX`.

**Imports y módulos:**
- Path alias `@/` → `src/`. Imports relativos SOLO dentro del mismo módulo/carpeta.
- Orden fijo (enforced con ESLint `import/order`): 1) framework (react/next) ·
  2) librerías externas · 3) alias internos `@/` · 4) relativos · 5) estilos/assets.
- Barrels (`index.ts`) SOLO en `components/ui/`. Prohibidos barrels profundos o
  re-exports en cascada (rompen tree-shaking y crean ciclos).
- Cero dependencias circulares. Cero imports no usados.

**Boundaries de capas (las dependencias apuntan en una sola dirección):**
`app/rutas → sections → layout/ui → hooks/lib → types`.
- `ui/` NUNCA importa de `sections/` ni de `app/`. `lib/` no importa componentes.
- Lo que solo usa UN componente vive colocado junto a él; se promueve a `ui/`/`lib/`
  al segundo uso (rule of two) — ni antes (especulación) ni después (duplicación).

**Tamaño y complejidad (límites duros):**
- Archivo ≤ ~250 líneas · función/componente ≤ ~40 líneas · máx. 3 niveles de anidación.
- Early returns sobre `if/else` anidados. Una responsabilidad por función/componente.
- Si un componente acumula >5–6 props o lógica mixta → se divide o se extrae un hook.

**TypeScript (strict de verdad):**
- `strict: true` + cero `any` (usa `unknown` + narrowing) + cero `@ts-ignore`
  (si es inevitable: `@ts-expect-error` con comentario del porqué).
- Props tipadas con `interface` exportada junto al componente. Tipos compartidos en
  `src/types/`; tipos locales, colocados.

**Configuración y entorno:**
- Env vars validadas en un solo punto (`src/lib/env.ts` con Zod): la app FALLA al
  arrancar si falta una var, nunca en runtime a mitad de un flujo. Cero `process.env`
  suelto en componentes. `.env.example` siempre sincronizado.

**Robustez de UI:**
- Toda vista con datos diseña sus 4 estados: loading / empty / error / success.
- Error boundaries por ruta. Nada de UI que "explota en blanco".

**Git y documentación:**
- Conventional Commits (`feat:`, `fix:`, `refactor:`, `chore:`, `docs:`) — commits
  atómicos por componente/feature, mensajes en inglés.
- `docs/ARCHITECTURE.md`: el frontend-architect lo genera en Fase 4 (mapa de carpetas,
  flujo de datos, decisiones de stack). Decisión no obvia → ADR corto en `docs/adr/`
  (contexto · decisión · consecuencias, ~15 líneas).
- README con: qué es, stack, setup en ≤3 comandos, scripts disponibles.

---

## 9. Protocolo de iteración (TODO cambio post-entrega, del botón a la web completa)

**El problema que mata proyectos:** cada iteración hecha como parche aislado acumula
código muerto, hardcodes y estilos mezclados (entropía de software). **La regla madre:**
tras cualquier iteración, nadie debe poder distinguir qué código es de la v1 y qué del
parche 14 — *todo debe parecer pensado y escrito desde el principio*. Si el parche se
nota, la iteración NO está terminada.

### 9.1 Antes de tocar una línea
Leer SIEMPRE: `.mateo/context.md` · `docs/ARCHITECTURE.md` · `design-system/MASTER.md` ·
los archivos del área a cambiar. El cambio se diseña DENTRO de la arquitectura existente,
no encima de ella.

### 9.2 Cambiar en el lugar correcto
- ¿Valor de diseño (color, spacing, radio, motion)? → se cambia el **token**, jamás el componente.
- ¿Comportamiento de algo compartido? → el **componente base / variante (CVA)**, jamás una copia.
- ¿Lógica nueva? → en la capa que corresponde (§8.4 boundaries), no inline donde quedó cómodo.
- PROHIBIDO el caso especial parcheado donde corresponde una variante/prop.

### 9.3 Boy Scout Rule (no negociable)
El área tocada queda MÁS limpia de lo que estaba: si en la zona del cambio hay hardcode,
duplicación o código muerto, se limpia en esa misma iteración. (Solo el área tocada — no
licencia para refactors masivos no pedidos.)

### 9.4 Sweep de cierre (obligatorio al terminar CADA iteración)
1. **Código muerto:** correr `knip` (+ ESLint `no-unused-vars`) → eliminar archivos,
   exports, deps, props y estados huérfanos que la iteración dejó atrás.
2. **Hardcode:** grep zero-hardcode (§4) sobre los archivos tocados → todo a tokens.
3. **Duplicación:** ¿la iteración copió markup/lógica que ya existía? → extraer (rule of two).
4. **Consistencia §8:** naming, orden de imports, boundaries, límites de tamaño, comentado §8.3.
5. **La prueba final:** releer el diff y preguntarse *"¿se nota que esto fue un parche?"*
   Estilo distinto, excepción rara, comentario tipo "quick fix" → se rehace hasta que no se note.

### 9.5 QA proporcional al tamaño
- **Iteración grande** (sección/página/feature nueva, refactor): ciclo completo con
  `qa-reviewer` (checklist §4 + visual-diff si hay refs).
- **Iteración pequeña** (botón, copy, estilo puntual): mini-checklist obligatorio —
  build + TS strict sin errores · sin hardcode nuevo · sin `console.*` · responsive del
  área tocada (viewports §4) · sweep 9.4 ejecutado.

### 9.6 Cierre de iteración
Actualizar `.mateo/context.md` (qué cambió y por qué). Decisión arquitectónica → ADR.

---

## 10. Proyectos existentes (brownfield) — dos modos, nunca un híbrido

Cuando el studio entra a un proyecto que NO construyó, mateo pregunta al usuario qué modo
aplica ANTES de tocar código. Lo peor que existe es el punto medio: mitad del código con
un estilo, mitad con otro.

### Modo A — Adopción total (refactorizar, componentizar, tokenizar TODO)
Traer el proyecto completo al estándar del studio: por dentro todo nuevo (§8), por fuera
**visualmente idéntico**. Es "hacer de 0 dejándolo exactamente igual".

1. **Baseline visual PRIMERO** (antes de tocar nada): playwright → screenshots full-page
   del sitio ACTUAL en 375/768/1024/1440 → `.refs/baseline/`. Sin baseline no se refactoriza.
2. **Auditoría** (frontend-architect): inventario de lo que hay — páginas, componentes
   de facto, valores hardcodeados (candidatos a token), duplicaciones, código muerto.
3. **Blueprint de migración**: mapa "estructura actual → esqueleto canónico §8" + design
   tokens extraídos de los valores reales del sitio (los colores/espaciados QUE YA TIENE,
   a OKLCH). El design system se deriva del sitio, no se inventa.
4. **Migración por secciones** (strangler fig, sofia): sección a sección, nunca big-bang.
   Cada sección migrada cumple §8 completo (tokens, componentes, comentado, boundaries).
5. **Visual-diff contra la propia baseline** (qa-reviewer) tras cada sección: el render
   nuevo vs `.refs/baseline/` → cualquier desviación visual es un bug del refactor → rebote.
6. Al terminar: sweep §9.4 global + `docs/ARCHITECTURE.md` + `.mateo/context.md` + CLAUDE.md
   del proyecto. Desde ese momento el proyecto itera bajo §9.

### Modo B — Intervención puntual (respetar las reglas de ESA casa)
Solo se arregla algo específico y el proyecto NO se adopta: **la consistencia local gana
al estándar del studio** (principio de las style guides de Google/Airbnb: sé consistente
con el código circundante).

- Detectar y seguir las convenciones existentes: naming, estructura, manera de estilar,
  patrones de estado — aunque contradigan §8. NO introducir el estilo del studio en una
  base que tiene el suyo.
- Boy Scout SOLO dentro del área tocada y respetando las convenciones locales.
- Sí aplican siempre (son calidad, no estilo): no romper el build, TS/lint sin errores
  nuevos, no dejar código muerto creado por el cambio, no `console.*`, los 4 estados de
  UI si se crea una vista nueva.
- Si la base está tan mal que arreglar "a su manera" perpetúa el problema → mateo lo
  reporta al usuario y propone subir a Modo A. No se decide en silencio.

### Nota — Apps/programas desktop existentes (Qt/PyQt/PySide, Electron viejo, etc.)
El §10 aplica igual, con dos adaptaciones:
- **Baseline sin Playwright**: la referencia visual se captura con screenshots de la
  ventana del programa (manuales o por script del SO) en sus tamaños típicos → `.refs/baseline/`.
  El visual-diff del qa-reviewer compara contra esas capturas.
- **Mateo presenta la decisión de ruta ANTES del modo**:
  - **Ruta A — Rediseñar dentro del framework nativo** (p.ej. Qt con QSS/QML): para
    programas-herramienta donde el valor es UX, densidad de información y consistencia.
    Los design tokens se materializan como constantes del framework (QSS centralizado),
    token-first aplica igual: cero colores/espaciados hardcodeados en la lógica.
  - **Ruta B — Migrar la UI a web tech** (Tauri preferido) manteniendo el backend
    existente (p.ej. Python como sidecar/API local): solo si el rediseño es profundo y
    el proyecto gana con el stack web completo del studio. Más caro; evaluar cuánta
    lógica vive enredada en la UI actual antes de proponerla.
