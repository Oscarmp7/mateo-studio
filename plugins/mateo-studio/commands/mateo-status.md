---
description: Resume en qué quedó el proyecto del studio — decisiones, avance y qué sigue
---

Reconstruye el estado del proyecto actual para retomarlo sin perder contexto. Es el
comando de "¿en qué nos quedamos?" después de días sin tocar el proyecto.

## Fuentes (lee las que existan, en este orden)
1. `.mateo/context.md` — memoria del proyecto: cliente, stack, decisiones, hecho, pendientes.
2. `docs/ARCHITECTURE.md` — mapa del proyecto y decisiones de stack.
3. `DESIGN.md` + `design-system/MASTER.md` — dirección estética aprobada.
4. `git log --oneline -15` y `git status --short` — avance real y trabajo sin commitear.
5. `docs/adr/` — decisiones arquitectónicas registradas.

## Reporte al usuario (conciso, en español)
1. **Qué es el proyecto** (1–2 líneas) y stack.
2. **Dónde quedó**: lo último hecho (según context.md + git log) y si hay trabajo sin
   commitear.
3. **Decisiones clave vigentes** (design system, arquitectura, ADRs relevantes).
4. **Pendientes** declarados en `.mateo/context.md`.
5. **Sugerencia de siguiente paso** concreta (una, no un menú).

## Reglas
- Si NO hay `.mateo/context.md` ni rastro del studio: dilo claramente y ofrece dos
  caminos — arrancar el flujo completo (`/mateo`) o adoptar el proyecto existente
  (playbook §10, Mateo preguntará el modo A/B).
- Si `context.md` contradice el git log (memoria desactualizada), repórtalo y ofrece
  actualizarlo.
- NO modifiques nada — este comando solo lee y reporta.
