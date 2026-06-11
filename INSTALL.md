# Instalar mateo-studio

Guía para dejar el studio funcionando en cualquier PC. Pensada para que **no tengas que
instalar skills, plugins ni MCPs a mano** — todo viene en el paquete.

---

## Requisitos mínimos (lo único que necesitas de tu lado)

1. **Claude Code** instalado.
2. **Node.js 18+** (los MCPs corren con `npx`; sin Node no se pueden lanzar).
3. **Git** (para instalar el plugin desde GitHub y para `/mateo-sync`).

Eso es todo. Las 6 personas del studio, el playbook y todas las skills de diseño van
**dentro** del plugin.

---

## Instalación (3 comandos en Claude Code)

```text
/plugin marketplace add Oscarmp7/mateo-studio
/plugin install mateo-studio
```

Luego **reinicia la sesión** (los MCPs y el hook cargan al inicio). Verifica con:

```text
/mateo
```

Debe arrancar el director del studio. Si ves los comandos `/mateo-*` (`/mateo-init`,
`/mateo-clone`, `/mateo-qa`, `/mateo-design-system`, `/mateo-status`, `/mateo-sync`)
al escribir `/`, quedó bien instalado.

**Primer paso recomendado:** corre `/mateo-init` — verifica Node, MCPs, keys y skills,
y te deja la lista exacta de lo que falte.

---

## MCPs: qué funciona solo y qué necesita tu API key

El plugin **declara sus MCPs** (`.mcp.json`), así que se lanzan solos al activarlo.

**Funcionan sin configurar nada** (solo con Node):
- `context7` — docs actualizadas de librerías
- `playwright` — screenshots, clonado, visual-diff, responsive
- `shadcn` / `magicui` — componentes

> Para playwright, la primera vez corre una sola vez: `npx playwright install chromium`.

**Necesitan TU propia API key** (opcionales — el studio funciona sin ellos):
| MCP | Variable de entorno | Dónde sacar la key |
|-----|---------------------|--------------------|
| `github` | `GITHUB_PERSONAL_ACCESS_TOKEN` | github.com → Settings → Developer settings → PAT |
| `magic` (21st.dev) | `MAGIC_API_KEY` | https://21st.dev |

Para activarlas, define la variable de entorno antes de abrir Claude Code. Ejemplo:

```powershell
# Windows (PowerShell)
$env:GITHUB_PERSONAL_ACCESS_TOKEN = "ghp_tu_token"
```
```bash
# macOS / Linux
export GITHUB_PERSONAL_ACCESS_TOKEN="ghp_tu_token"
```

Si una key no está, Mateo lo detecta y **avisa en vez de romperse** (degradación elegante).
No te bloquea el resto del studio.

---

## Mantener las skills al día

Las skills de diseño vienen vendored (una "foto"). Para traer la última versión de sus
autores:

```text
/mateo-sync
```

---

## Cómo se usa

- `/mateo` — arranca el flujo completo (brief, URL o imagen → web production-ready).
  También maneja iteraciones sobre proyectos entregados y adopción de proyectos
  existentes (incluidos programas desktop — pregunta el modo antes de tocar código).
- `/mateo-init` — verifica e instala lo que el studio necesita (correr al instalar).
- `/mateo-clone <url>` — clona y mejora una web al pie de la letra.
- `/mateo-design-system` — genera solo la dirección de arte + design system.
- `/mateo-qa` — corre el checklist de producción + anti-IA sobre el proyecto actual.
- `/mateo-status` — resume en qué quedó el proyecto para retomarlo sin perder contexto.

Mateo conversa en español y entrega código (en inglés) que **no parece hecho por IA**.
