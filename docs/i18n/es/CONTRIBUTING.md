<!-- i18n-sync: source=CONTRIBUTING.md@fa82c3d lang=es -->
> 🌐 Este documento es una traducción asistida por IA. **El inglés es la fuente canónica** ([Principle I](../../../.specify/memory/constitution.md)); en caso de discrepancia, prevalece el inglés. Ver otros idiomas: [English](../../../CONTRIBUTING.md) · [中文](../zh/CONTRIBUTING.md) · [हिन्दी](../hi/CONTRIBUTING.md) · [Español](../es/CONTRIBUTING.md) · [Français](../fr/CONTRIBUTING.md) · [العربية](../ar/CONTRIBUTING.md) · [বাংলা](../bn/CONTRIBUTING.md) · [Português](../pt/CONTRIBUTING.md) · [Русский](../ru/CONTRIBUTING.md) · [اردو](../ur/CONTRIBUTING.md) · [Bahasa Indonesia](../id/CONTRIBUTING.md)

# Contribuir a Spec Jedi

Spec Jedi está construido bajo su propia [constitución](../../../.specify/memory/constitution.md)
— un conjunto versionado de reglas innegociables contra el cual se verifica todo cambio,
incluido este. Este documento es el compañero práctico de "cómo contribuyo realmente";
la constitución es la declaración definitiva de *por qué* existe cada regla.

## Antes de escribir cualquier cosa

1. **Lee la constitución.** Como mínimo, echa un vistazo a los
   [Principios Fundamentales](../../../.specify/memory/constitution.md) I-XX — la mayoría
   de las preguntas de contribución ("¿necesito pruebas?", "¿cómo debería llamarse esto?",
   "¿necesita esto investigación primero?") ya están respondidas ahí.
2. **La investigación competitiva es obligatoria para cualquier nueva skill `specjedi-*`**
   (Principle II, no negociable). Antes de proponer una nueva skill, compárala con
   [github/spec-kit](https://github.com/github/spec-kit) y al menos otras diez
   herramientas SDD públicamente disponibles, y nombra al menos una contribución genuina
   que tu propuesta hace más allá de lo que cualquiera de ellas ya ofrece. Escribe esto en
   un `research.md` junto a la especificación de la funcionalidad — ver
   `specs/001-specjedi-pipeline/research.md` y `specs/002-specjedi-onboard/research.md`
   para la forma esperada.
3. **Revisa `references/skill-roadmap.md`** — tu idea puede que ya esté delimitada ahí
   con notas de priorización; extender una propuesta existente suele ser mejor que abrir
   una competidora.

## Cómo se entregan los cambios

Este proyecto está basado en trunk (Principle X):

- `main` es el tronco. **Ningún commit aterriza jamás directamente en `main`.**
- Cada cambio sale en su propia rama de vida corta como un pull request.
- CI (`ci-gate`) ejecuta toda la batería de validación — lint estructural, verificaciones
  multiplataforma (Linux/macOS/Windows, Principle XIII) — en cada PR. Un PR solo se
  fusiona una vez que cada verificación requerida está en verde; no hay override manual
  ni ruta de "fusionar de todos modos".
- **Auto-fusión basada solo en las verificaciones es un privilegio de las PR del propio
  dueño del repositorio.** Si eres un colaborador externo, tu PR necesita una revisión
  explícita APPROVED del dueño además de un `ci-gate` en verde antes de fusionarse — ver
  el job `owner-gate` en `.github/workflows/validate.yml` para el mecanismo exacto.

## Añadir o cambiar una skill `specjedi-*`

Las skills nuevas y los cambios sustanciales a skills existentes siguen el propio pipeline
de SDD de este proyecto — el mismo que Spec Jedi entrega como producto (sección
Development Workflow de la constitución):

1. **Investigar** (Principle II) — ver arriba.
2. **Especificar** — un `spec.md` con historias de usuario priorizadas, requisitos
   funcionales, y criterios de éxito medibles. Marca la ambigüedad genuina con
   `NEEDS CLARIFICATION` en lugar de adivinar (Principle V).
3. **Aclarar** — resuelve cualquier ambigüedad marcada antes de planificar sobre una
   suposición.
4. **Planificar** — un `plan.md` con una verdadera compuerta de Constitution Check: si tu
   cambio violaría un principio, ya sea simplifícalo o registra la justificación
   explícitamente en Complexity Tracking, nunca pases la compuerta silenciosamente.
5. **Tareas** — un `tasks.md` ordenado por dependencias, con pruebas primero donde el
   plan requiera código (Principle VI).
6. **Implementar** — solo a través de una rama de funcionalidad y PR (ver arriba), nunca
   un commit directo al tronco.

Cada directorio `specs/NNN-feature/` entregado en este repositorio es un ejemplo
funcional de esta forma — `specs/001-specjedi-pipeline/` y `specs/002-specjedi-onboard/`
son las referencias más completas.

## Estándar de Autoría de Skills y Prompt Engineering

Cada `SKILL.md` en este repositorio, nuevo o modificado, DEBE incluir (Principle XIX;
detalle completo en
[`references/skill-authoring-standard.md`](../../../references/skill-authoring-standard.md)):

- Un persona claro y una declaración de tarea.
- Un formato de salida definido.
- Al menos un ejemplo completo de "entrada → salida" trabajado.
- Instrucción de cadena de pensamiento (chain-of-thought) para cualquier decisión de
  juicio no determinista.
- Guardarraíles explícitos de **Always** / **Never**.
- Criterios de éxito verificables — hechos comprobables, no vibras.
- Calibración de audiencia donde la propia narración de la skill lo necesite (de
  principiante a avanzado, Principle I).

## Validación antes de solicitar revisión

Ejecuta el lint estructural localmente antes de abrir un PR:

```bash
bash scripts/validate.sh      # macOS/Linux
pwsh scripts/validate.ps1     # Windows
```

Ambos deben pasar — este proyecto soporta Linux, macOS y Windows por igual
(Principle XIII); un cambio que solo funciona en una plataforma no está terminado.

Si tu skill produce código, también necesita un dry run basado en escenarios confirmando
que sus preguntas de elicitación y lógica de ramificación se comportan según lo
documentado (Principle IX) — describe qué ejercitaste en la descripción del PR.

## Voz y nomenclatura

- Las skills de producto se nombran `specjedi-*`, nunca `speckit-*` — esta última es
  herramienta interna de bootstrap distribuida (vendored) que este repositorio usa para
  construirse a sí mismo, no algo que los usuarios finales instalan (Principle XV). Ver
  la sección "Cómo Spec Jedi se construye a sí mismo" del README si esta distinción no
  está clara.
- La narración de cara al usuario final (no el contenido literal de los campos
  generados de `spec.md`/`plan.md`/`tasks.md`) usa la voz con sabor a Star Wars propia
  de Spec Jedi (Principle XII) — ver `references/star-wars-lexicon.md` para el léxico de
  referencia. El *contenido* del artefacto generado se mantiene preciso y apropiado en
  jerga; la voz aplica a la propia narración de la skill alrededor de él.

## Mantener el README honesto

Si tu cambio añade una skill entregada, un nuevo hecho digno de un badge, o de otro modo
cambia lo que es verdad sobre el proyecto, actualiza `README.md` en el mismo PR — la
tabla "Lo que obtienes hoy", la numeración de Quickstart, y el diagrama Mermaid del
pipeline necesitan mantenerse sincronizados (Principle XVI). Revisa la fila de badges
antes de abrir el PR: confirma que cada badge existente todavía se lee correctamente, y
añade uno nuevo solo si tu cambio es un hecho genuinamente nuevo y relevante que merece
señalarse — nunca un valor escrito a mano que pueda quedar obsoleto (Distribution &
Ecosystem Standards).

## Preguntas

Si algo en la constitución no está claro, eso vale la pena plantearlo como un issue por
derecho propio — una regla que nadie puede seguir porque es ambigua es un defecto en la
constitución, no en ti.
