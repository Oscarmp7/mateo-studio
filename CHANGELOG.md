# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/). Versionado semver.

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
