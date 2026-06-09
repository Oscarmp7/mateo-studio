# mateo-studio

Un **studio de diseño y frontend multi-agente** para Claude Code, empaquetado como plugin
autocontenido. El director **Mateo** orquesta a 6 agentes especialistas por fases, con gates
de aprobación, y entrega frontend production-ready que **NO parece hecho por IA**.

> Instalación rápida → ver **[INSTALL.md](./INSTALL.md)**. Solo necesitas Claude Code + Node.js.

## Qué trae el paquete

- **Orquestador `mateo`** (skill, corre en tu sesión — puede pausar en los gates).
- **6 agentes especialistas** (subagentes aislados):
  `strategist` · `ux-architect` · `art-director` · `frontend-architect` · `sofia` (builder) · `qa-reviewer`.
- **Playbook compartido** — principios anti-IA, protocolo de fidelidad visual (clonado +
  imagen), checklist de producción, índice de skills, guía de MCPs.
- **Skills de diseño vendored** (`skills-lib/`) — el motor del studio viaja dentro del
  plugin; una PC nueva no necesita instalar nada extra.
- **MCPs declarados** (`.mcp.json`) — se lanzan solos al activar el plugin (los que llevan
  API key son opcionales; ver INSTALL).

## El flujo

```
brief / URL / imagen
   └─ mateo (Fase 0: intake → PRODUCT.md + refs)
        ├─ strategist        (estrategia, posicionamiento)
        ├─ ux-architect      (flujos, IA, wireframes)        → GATE
        ├─ art-director      (3 direcciones → design system) → GATE (el más importante)
        ├─ frontend-architect (stack exacto, arquitectura)
        ├─ sofia             (construcción production-ready)
        └─ qa-reviewer       (checklist + visual-diff + anti-IA) → GATE → entrega
```

## Comandos

| Comando | Qué hace |
|---------|----------|
| `/mateo` | Flujo completo desde un brief, URL o imagen |
| `/clone <url>` | Clona y mejora una web al pie de la letra |
| `/design-system` | Solo la dirección de arte + design system |
| `/qa` | Checklist de producción + anti-IA sobre el proyecto actual |
| `/mateo-sync` | Actualiza las skills vendored desde sus repos de origen |

## Mantener y contribuir

- **[MAINTAINING.md](./MAINTAINING.md)** — cómo editar, actualizar skills, versionar y publicar.
- **[CHANGELOG.md](./CHANGELOG.md)** — historial de versiones.

## Créditos

Las skills de diseño de terceros vendored en `skills-lib/` pertenecen a sus autores
originales. Ver **[CREDITS.md](./CREDITS.md)**.

## Autor

Oscar Matos.
