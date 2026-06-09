# Mantener mateo-studio

Guía para Oscar: cómo editar, actualizar, versionar y publicar el plugin sin romperlo.
Repo: `github.com/Oscarmp7/mateo-studio` · Carpeta local: `Dev/mateo-studio`.

---

## 1. Mapa del repo (qué es cada cosa)

```
mateo-studio/                              ← el repo ES el marketplace
├── .claude-plugin/marketplace.json        ← lista el plugin; apunta a ./plugins/mateo-studio
└── plugins/mateo-studio/                   ← el plugin en sí
    ├── .claude-plugin/plugin.json          ← nombre, versión, autor del plugin
    ├── skills/mateo/SKILL.md               ← el ORQUESTADOR (flujo, fases, gates)
    ├── agents/*.md                         ← los 6 especialistas
    ├── studio/playbook.md                  ← estándar compartido (anti-IA, checklist, MCPs, índice skills)
    ├── skills-lib/                         ← skills de terceros VENDORED (el motor de diseño)
    ├── .mcp.json                           ← MCPs que el plugin auto-declara
    ├── commands/*.md                       ← atajos /clone /qa /design-system /mateo-sync
    ├── hooks/                              ← session-start (escribe la ruta) + run-hook.cmd
    └── scripts/sync-skills.sh              ← refresca skills-lib desde sus repos
```

**Fuente de verdad:** la carpeta local `Dev/mateo-studio`. Editas ahí → commit → push.
Tu Mateo de trabajo diario (`~/.claude/skills/mateo`, `~/.claude/agents/`) es **independiente**:
este plugin NO lo toca y no se actualiza solo desde él (ver §7 si quieres sincronizarlos).

---

## 2. Editar el comportamiento del studio

- **Cambiar el flujo, fases o gates** → `plugins/mateo-studio/skills/mateo/SKILL.md`.
- **Cambiar un especialista** (qué hace, qué skills usa) → `plugins/mateo-studio/agents/<agente>.md`.
- **Cambiar estándares compartidos** (principios anti-IA, checklist, definición de production-ready,
  índice de skills, guía de MCPs) → `plugins/mateo-studio/studio/playbook.md`. Es el sitio correcto
  para reglas que aplican a varios agentes (no las dupliques en cada agente).

Tras editar, prueba en local (§6), sube (§5) y corre `/plugin update`.

---

## 3. ⚠️ La regla de oro que NO se rompe: rutas

`${CLAUDE_PLUGIN_ROOT}` **solo** se expande en `hooks.json`, `.mcp.json`, `.lsp.json` y `plugin.json`.
**NUNCA funciona dentro del cuerpo de un SKILL.md o un agente .md** (ahí es texto literal).

Por eso el mecanismo es:
1. El hook `session-start` escribe la ruta real del plugin en `~/.claude/.mateo-studio-root`.
2. La skill `mateo` y los agentes resuelven esa ruta con `cat "$HOME/.claude/.mateo-studio-root"`
   y de ahí arman las rutas a `studio/playbook.md` y `skills-lib/`.
3. Mateo además le pasa `PLUGIN_ROOT` a cada agente en el prompt.

**Si editas un agente o la skill, mantén ese patrón.** No metas rutas absolutas de tu PC
(`C:\Users\omato\...`) ni esperes que `${CLAUDE_PLUGIN_ROOT}` se expanda en el markdown.

---

## 4. Skills vendored (`skills-lib/`)

### Actualizar a la última versión de sus autores
```
/mateo-sync          (o: bash plugins/mateo-studio/scripts/sync-skills.sh)
```
El script clona los repos de origen conocidos y refresca las carpetas. Luego commit + push.

### Añadir una skill nueva
1. Copia su carpeta dentro de `skills-lib/<categoría>/<skill>/` (debe tener su `SKILL.md`).
2. Si quieres que `/mateo-sync` la mantenga al día, añade una línea a `SOURCES` en
   `scripts/sync-skills.sh`:  `"<dest-bajo-skills-lib>|<owner/repo>|<subpath>"`.
3. Refiérela en el agente que la use y/o en el §5 del playbook.
4. Acredita al autor en `CREDITS.md`.

### Quitar una skill
Borra su carpeta de `skills-lib/`, quítala del playbook §5 y del agente que la mencione.

> Las skills vendored son una "foto". No se actualizan solas vía `/plugin update` (eso solo
> trae cambios del repo mateo-studio). Para refrescarlas: `/mateo-sync` y luego push.

---

## 5. Versionar y publicar (el ciclo normal)

1. Edita en `Dev/mateo-studio`.
2. **Sube la versión** en DOS sitios (deben coincidir):
   - `plugins/mateo-studio/.claude-plugin/plugin.json` → `"version"`
   - `.claude-plugin/marketplace.json` → `"version"` del plugin
   Usa semver: parche `1.0.x` (fixes), menor `1.x.0` (features), mayor `x.0.0` (cambios grandes).
3. Anota el cambio en `CHANGELOG.md` (créalo si no existe).
4. Commit + push:
   ```
   git -C "Dev/mateo-studio" add -A
   git -C "Dev/mateo-studio" commit -m "feat: <qué cambió>"
   git -C "Dev/mateo-studio" push
   ```
5. Tú y tu amigo corren `/plugin update` para recibir la versión nueva.

---

## 6. Probar ANTES de publicar (no te saltes esto)

- **JSON válidos:** que `marketplace.json`, `plugin.json`, `.mcp.json`, `hooks/hooks.json` parseen.
- **El hook resuelve la ruta:** corre `bash plugins/mateo-studio/hooks/session-start` y verifica
  que `cat ~/.claude/.mateo-studio-root` apunte al plugin y que exista `<ruta>/studio/playbook.md`.
- **Sin `.git` anidados** en `skills-lib/` (se vuelven submódulos rotos) ni archivos enormes.
- **Prueba de instalación real:** lo más fiable es instalar desde GitHub en una máquina/usuario
  limpio (idealmente el de tu amigo, sin tu Mateo local que genera nombres duplicados).

---

## 7. (Opcional) Sincronizar tu Mateo local → el plugin

Si mejoras tu Mateo de trabajo (`~/.claude/skills/mateo`, `~/.claude/agents/`, `~/.claude/studio/
playbook.md`) y quieres llevar esos cambios al plugin para compartirlos:
1. Copia los archivos cambiados a `Dev/mateo-studio/plugins/mateo-studio/` (skills/agents/studio).
2. **Re-portabiliza las rutas:** cambia cualquier `C:\Users\omato\.claude\studio\playbook.md` →
   referencia a PLUGIN_ROOT, y `...Dev\Library\skills-library\` → `PLUGIN_ROOT/skills-lib/` (§3).
3. Sube la versión, commit + push (§5).

> No hay sync automático local→plugin a propósito: tu Mateo diario y el paquete para regalar son
> cosas distintas. Mantenerlos separados evita romper uno al tocar el otro.

---

## 8. Lecciones del intento viejo (por qué está hecho así)

El plugin anterior (`webcraft`) nunca instalaba. Lo que aprendimos y NO repetir:
- ❌ **Marketplace local** (`source: local, path: C:\...`) → frágil, apuntaba a carpeta vacía.
  ✅ Aquí: marketplace de **GitHub** (`/plugin marketplace add Oscarmp7/mateo-studio`).
- ❌ **Hook que inyectaba "You are Mateo"** en cada sesión → secuestraba todo Claude Code.
  ✅ Aquí: el hook solo **escribe una ruta**, no toca el prompt. Mateo se invoca con `/mateo`.
- ❌ Plugin en la raíz con `source: "./"`. ✅ Aquí: en `plugins/mateo-studio/` (patrón probado).
- ❌ Rutas absolutas del disco. ✅ Aquí: todo se resuelve vía PLUGIN_ROOT (§3).
- ❌ Esfuerzo disperso en Cursor/OpenCode/Codex. ✅ Aquí: enfocado en Claude Code.
