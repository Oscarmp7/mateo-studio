---
description: Actualiza las skills de diseño vendored del plugin desde sus repos de origen
---

Actualiza las skills de terceros vendored dentro del plugin a su última versión upstream.

1. Resuelve PLUGIN_ROOT (`cat "$HOME/.claude/.mateo-studio-root"`).
2. Ejecuta el script de sync:
   ```bash
   bash "<PLUGIN_ROOT>/scripts/sync-skills.sh"
   ```
3. Reporta al usuario qué skills se actualizaron (y cuáles fallaron, si alguna).
4. Recuérdale que, para distribuir la versión actualizada a otra persona, debe hacer
   commit + push del repo `mateo-studio` y que el otro corra `/plugin update`.

Nota: el script clona los repos de origen conocidos y refresca `skills-lib/`. Las skills
sin repo de origen rastreable se dejan intactas.
