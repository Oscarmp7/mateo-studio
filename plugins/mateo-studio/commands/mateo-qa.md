---
description: Corre el checklist de producción + anti-IA del studio sobre el proyecto actual
---

Invoca al agente `qa-reviewer` del studio sobre el proyecto actual${ARGUMENTS:+ — foco: $ARGUMENTS}.

1. Resuelve PLUGIN_ROOT (`cat "$HOME/.claude/.mateo-studio-root"`).
2. Lanza `Agent(qa-reviewer, "PLUGIN_ROOT=<ruta>. Revisa el proyecto en <cwd>. ...")`
   pasándole el contexto del proyecto y las rutas de `.refs/` si existen (para visual-diff).
3. El qa-reviewer corre el checklist completo del playbook §4 (fidelidad, visual, responsive,
   a11y, SEO, performance), el slop-detector anti-IA, el zero-hardcode audit y la auditoría
   de estructura/estándar de ingeniería (§8: esqueleto canónico, comentado, naming, boundaries).
   Si es una iteración, verifica también el sweep de cierre §9.4 (knip, sin código muerto).
4. Devuelve APROBADO o un rebote con fixes precisos. Presenta el veredicto al usuario.
