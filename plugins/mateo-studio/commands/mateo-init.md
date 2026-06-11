---
description: Verifica e instala todo lo que el studio de Mateo necesita en esta máquina (preflight + auto-setup)
---

Prepara el entorno del studio de Mateo en esta máquina/proyecto: verifica las
dependencias e instala/configura lo que falte. Reporta TODO — prohibido degradar en
silencio (playbook §6).

## Paso 1 — Resuelve PLUGIN_ROOT
`cat "$HOME/.claude/.mateo-studio-root"`. Si no existe:
`find "$HOME/.claude/plugins" -path "*mateo-studio/studio/playbook.md" | head -1`.

## Paso 2 — Verifica (4 categorías)
1. **Node.js** instalado (`node --version`) — los MCPs del plugin lo necesitan para
   auto-lanzarse con `npx`.
2. **MCPs del plugin cargados en ESTA sesión**: busca tools `mcp__<server>__*`
   (context7, playwright, shadcn, magicui; github y magic si hay keys). Un MCP declarado
   en `PLUGIN_ROOT/.mcp.json` pero no cargado = la sesión necesita reiniciarse o falta
   su requisito.
3. **Keys de entorno** para los MCPs que las usan: `GITHUB_PERSONAL_ACCESS_TOKEN`
   (github), `MAGIC_API_KEY` (magic), `SUPABASE_ACCESS_TOKEN` (supabase). Revisa si ya
   existen antes de pedirlas.
4. **Skills-lib del plugin**: existe `PLUGIN_ROOT/skills-lib/` con sus carpetas
   (frontend/, marketing/, business/...).

## Paso 3 — Arregla lo que falte
- **Node ausente** → indica instalarlo (https://nodejs.org, versión LTS) — no se puede
  automatizar; deja el paso claro.
- **Key ausente** → pídela al usuario y explícale cómo dejarla persistente como variable
  de entorno del sistema (en Windows: `setx NOMBRE "valor"`; en macOS/Linux: en su shell
  profile). NUNCA inventes una key ni dejes un placeholder roto sin avisar.
- **Skills-lib incompleta** → corre `/mateo-sync` (o
  `bash "<PLUGIN_ROOT>/scripts/sync-skills.sh"`).
- **Opcionales de alto valor**: plugins `impeccable` (slop detector) y `taste-skill` —
  si el usuario los quiere: `claude plugin install <plugin>@<marketplace>` (orígenes:
  pbakaus/impeccable · leonxlnx/taste-skill).

## Paso 4 — Reporte final (obligatorio)
Tabla con CADA recurso: ✅ ya estaba · 🔧 configurado ahora · ❌ acción manual (con el
comando/paso exacto) · ⏭️ omitido por decisión del usuario. Después:
1. Si se configuró algo que carga al inicio (MCPs, plugins, keys): avisa
   **"reinicia la sesión para que cargue"** — no hay hot-load, es límite de la plataforma.
2. Anota en `.mateo/context.md` qué quedó configurado y qué quedó degradado por decisión.

## Reglas
- No pidas keys que ya existen. No instales lo que el proyecto no va a usar.
- Todo faltante se reporta con su impacto concreto ("sin playwright no hay clonado ni
  visual-diff"), no con avisos vagos.
