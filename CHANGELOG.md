# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/). Versionado semver.

## [1.2.0] — 2026-06-11

### Added
- Comando `/mateo-status`: resume en qué quedó el proyecto (memoria, decisiones, git,
  pendientes) para retomarlo sin perder contexto.

### Changed
- **Todos los comandos llevan ahora el prefijo `mateo-`**: `/clone` → `/mateo-clone`,
  `/qa` → `/mateo-qa`, `/design-system` → `/mateo-design-system`.
- `/mateo-qa` audita también estructura/estándar de ingeniería (§8) y sweep de iteración (§9.4).
- `/mateo-clone` deriva a `/mateo-init` cuando falta playwright.

## [1.1.0] — 2026-06-11

### Added
- Playbook §8: estructura canónica de proyectos (agnóstica de stack) + estándar de
  comentado/seccionado + estándar de ingeniería élite (naming, imports, boundaries,
  límites de tamaño, TS strict, env con Zod, 4 estados de UI, ADRs).
- Playbook §9: protocolo de iteración para TODO cambio post-entrega (Boy Scout rule,
  sweep de cierre con knip + zero-hardcode, QA proporcional).
- Playbook §10: modos brownfield — A (adopción total con baseline visual y migración
  strangler-fig) y B (intervención puntual respetando convenciones locales) + nota para
  apps desktop existentes (Qt/PyQt: baseline por screenshots, ruta nativa vs Tauri).
- Comando `/mateo-init`: preflight + auto-setup del entorno (Node, MCPs, keys, skills-lib).
- Preflight de capacidades en Fase 0 + regla anti-silencio (§5): nada se degrada sin avisar.
- Mateo genera un `CLAUDE.md` por proyecto al cierre (las sesiones futuras heredan §8/§9
  aunque no invoquen /mateo).

### Changed
- Todos los agentes corren ahora en **Opus** (calidad sobre costo).
- frontend-architect: `knip` obligatorio en el stack, entrega `docs/ARCHITECTURE.md` + ADRs,
  y modo auditoría/blueprint para brownfield.

## [1.0.0] — 2026-06-09

### Added
- Primera versión del plugin `mateo-studio` para Claude Code.
- Orquestador `mateo` (skill) + 6 agentes especialistas: strategist, ux-architect,
  art-director, frontend-architect, sofia (builder), qa-reviewer.
- Playbook compartido: principios anti-IA, protocolo de fidelidad visual (clonado + imagen),
  checklist de producción, índice de skills, guía de MCPs.
- 67 skills de diseño/desarrollo vendored en `skills-lib/` (autocontenido y portable).
- MCPs auto-declarados en `.mcp.json`: context7, playwright, shadcn, magicui (sin key) +
  github, magic (con API key opcional).
- Comandos: `/mateo`, `/clone`, `/qa`, `/design-system`, `/mateo-sync`.
- Hook `SessionStart` que resuelve la ruta del plugin sin inyectar contexto (no secuestra sesión).
- Script `sync-skills.sh` para refrescar las skills vendored desde sus repos de origen.
- Documentación: README, INSTALL, MAINTAINING, CREDITS.
