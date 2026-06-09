---
description: Clona y mejora una web existente al pie de la letra (flujo Mateo, modo clon)
---

Activa el studio de Mateo en **modo clonado** para: $ARGUMENTS

Sigue el protocolo de fidelidad visual del playbook (§3A):
1. Resuelve PLUGIN_ROOT (`cat "$HOME/.claude/.mateo-studio-root"`) y lee el playbook.
2. Con el MCP `playwright`, toma screenshots full-page en 375/768/1024/1440px de la URL
   y extrae DOM + CSS computado. Guarda todo en `.refs/clone/`.
3. Orquesta el flujo normal de Mateo (ux-architect deriva estructura del DOM →
   art-director replica paleta/tipografía/escala EXACTAS → sofia reconstruye →
   qa-reviewer hace visual-diff hasta calcar).
4. Respeta los gates de aprobación con el usuario.

Si no tienes el MCP `playwright` activo, avísale al usuario cómo activarlo antes de seguir.
