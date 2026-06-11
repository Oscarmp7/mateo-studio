---
description: Genera solo el design system (dirección de arte) para el proyecto o brief actual
---

Invoca al agente `art-director` del studio para producir SOLO el design system${ARGUMENTS:+ para: $ARGUMENTS}.

1. Resuelve PLUGIN_ROOT (`cat "$HOME/.claude/.mateo-studio-root"`) y lee el playbook (§2 anti-IA, §3 fidelidad).
2. Si existe `.mateo/context.md` o un PRODUCT.md, dáselos como contexto al art-director.
3. Lanza `Agent(art-director, "PLUGIN_ROOT=<ruta>. ...")` para que entregue las 3 direcciones
   estéticas (gate de elección con el usuario) y luego `design-system/MASTER.md` + `DESIGN.md`.
4. Respeta el gate: el usuario elige la dirección antes de producir el sistema final.
