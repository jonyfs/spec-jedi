<!-- i18n-sync: source=CONTRIBUTING.md@01f83f5 lang=pt -->
> 🌐 Este documento é uma tradução assistida por IA. **O inglês é a fonte
> canônica** ([Principle I](../../../.specify/memory/constitution.md)); em
> caso de divergência, prevalece o inglês. Ver outros idiomas:
> [English](../../../CONTRIBUTING.md) · [中文](../zh/CONTRIBUTING.md) ·
> [हिन्दी](../hi/CONTRIBUTING.md) · [Español](../es/CONTRIBUTING.md) ·
> [Français](../fr/CONTRIBUTING.md) · [العربية](../ar/CONTRIBUTING.md) ·
> [বাংলা](../bn/CONTRIBUTING.md) · [Português](../pt/CONTRIBUTING.md) ·
> [Русский](../ru/CONTRIBUTING.md) · [اردو](../ur/CONTRIBUTING.md) ·
> [Bahasa Indonesia](../id/CONTRIBUTING.md)

# Contribuindo para o Spec Jedi

O Spec Jedi é construído sob sua própria
[constitution](../../../.specify/memory/constitution.md) — um conjunto
versionado de regras inegociáveis contra o qual toda mudança, incluindo
esta, é verificada. Este documento é o companheiro prático de "como eu
realmente contribuo"; a constitution é a declaração definitiva do
*porquê* cada regra existe.

## Antes de escrever qualquer coisa

1. **Leia a constitution.** No mínimo, dê uma olhada nos
   [Core Principles](../../../.specify/memory/constitution.md) I-XX —
   a maioria das perguntas de contribuição ("preciso de testes?",
   "como isso deveria ser nomeado?", "isso precisa de pesquisa
   primeiro?") já têm respostas ali.
2. **Pesquisa competitiva é obrigatória para qualquer nova skill
   `specjedi-*`** (Principle II, inegociável). Antes de propor uma nova
   skill, compare-a com [github/spec-kit](https://github.com/github/spec-kit)
   e pelo menos outras dez ferramentas de SDD publicamente disponíveis,
   e nomeie pelo menos uma contribuição genuína que sua proposta faz
   além do que qualquer uma delas já oferece. Escreva isso em um
   `research.md` ao lado da especificação da feature — veja
   `specs/001-specjedi-pipeline/research.md` e
   `specs/002-specjedi-onboard/research.md` para a forma esperada.
3. **Verifique `references/skill-roadmap.md`** — sua ideia pode já
   estar delimitada lá com notas de priorização; estender uma proposta
   existente geralmente é melhor do que abrir uma concorrente.

## Como as mudanças são entregues

Este projeto é baseado em trunk (Principle X):

- `main` é o trunk. **Nenhum commit pousa diretamente no `main`.**
- Cada mudança sai em seu próprio branch de vida curta como um pull
  request.
- O CI (`ci-gate`) executa toda a bateria de validação — lint
  estrutural, verificações multiplataforma (Linux/macOS/Windows,
  Principle XIII) — em cada PR. Um PR só é mesclado uma vez que cada
  verificação obrigatória esteja verde; não há override manual nem
  caminho de "mesclar de qualquer jeito".
- **Auto-merge baseado apenas nas verificações é um privilégio dos
  próprios PRs do dono do repositório.** Se você é um colaborador
  externo, seu PR precisa de uma revisão APPROVED explícita do dono
  além de um `ci-gate` verde antes de mesclar — veja o job
  `owner-gate` em `.github/workflows/validate.yml` para o mecanismo
  exato.

## Adicionando ou mudando uma skill `specjedi-*`

Novas skills e mudanças substanciais em skills existentes seguem o
próprio pipeline de SDD deste projeto — o mesmo que o Spec Jedi entrega
como produto (seção Development Workflow da constitution):

1. **Pesquisar** (Principle II) — veja acima.
2. **Especificar** — um `spec.md` com histórias de usuário
   priorizadas, requisitos funcionais e critérios de sucesso
   mensuráveis. Marque ambiguidade genuína com `NEEDS CLARIFICATION`
   em vez de adivinhar (Principle V).
3. **Esclarecer** — resolva qualquer ambiguidade marcada antes de
   planejar sobre um palpite.
4. **Planejar** — um `plan.md` com um verdadeiro gate de Constitution
   Check: se sua mudança violasse um princípio, simplifique-a ou
   registre a justificativa explicitamente em Complexity Tracking,
   nunca passe pelo gate silenciosamente.
5. **Tarefas** — um `tasks.md` ordenado por dependências, com testes
   primeiro onde o plano exige código (Principle VI).
6. **Implementar** — somente através de um branch de feature e PR
   (veja acima), nunca um commit direto no trunk.

Todo diretório `specs/NNN-feature/` entregue neste repositório é um
exemplo funcional dessa forma — `specs/001-specjedi-pipeline/` e
`specs/002-specjedi-onboard/` são as referências mais completas.

## Skill Authoring e Prompt Engineering Standard

Todo `SKILL.md` neste repositório, novo ou modificado, DEVE incluir
(Principle XIX; detalhes completos em
[`references/skill-authoring-standard.md`](../../../references/skill-authoring-standard.md)):

- Um persona claro e uma declaração de tarefa.
- Um formato de saída definido.
- Pelo menos um exemplo completo de "entrada → saída" trabalhado.
- Instrução de cadeia de raciocínio (chain-of-thought) para qualquer
  decisão de julgamento não determinística.
- Guardrails explícitos de **Always** / **Never**.
- Critérios de sucesso verificáveis — fatos verificáveis, não
  sensações.
- Calibração de audiência onde a própria narração da skill precisar
  (de iniciante a avançado, Principle I).

## Validação antes de solicitar revisão

Rode o lint estrutural localmente antes de abrir um PR:

```bash
bash scripts/validate.sh      # macOS/Linux
pwsh scripts/validate.ps1     # Windows
```

Ambos devem passar — este projeto suporta Linux, macOS e Windows por
igual (Principle XIII); uma mudança que só funciona em uma plataforma
não está terminada.

Se sua skill produz código, ela também precisa de um dry run baseado
em cenários confirmando que suas perguntas de elicitação e lógica de
ramificação se comportam conforme documentado (Principle IX) —
descreva o que você exercitou na descrição do PR.

## Voz e nomenclatura

- Skills de produto são nomeadas `specjedi-*`, nunca `speckit-*` — a
  última é ferramentaria interna de bootstrap distribuída (vendored)
  que este repositório usa para se construir, não algo que usuários
  finais instalam (Principle XV). Veja a seção "Como o Spec Jedi
  constrói a si mesmo" do README se essa distinção não estiver clara.
- A narração voltada ao usuário final (não o conteúdo literal dos
  campos gerados de `spec.md`/`plan.md`/`tasks.md`) usa a voz com
  sabor de Star Wars própria do Spec Jedi (Principle XII) — veja
  `references/star-wars-lexicon.md` para o léxico de referência. O
  *conteúdo* do artefato gerado permanece preciso e apropriado em
  termos de jargão; a voz se aplica à própria narração da skill ao
  redor dele.

## Mantendo o README honesto

Se sua mudança adiciona uma skill entregue, um novo fato digno de
badge, ou de outra forma muda o que é verdade sobre o projeto, atualize
`README.md` no mesmo PR — a tabela "O que você tem hoje", a numeração
do Quickstart, e o diagrama Mermaid do pipeline precisam permanecer
sincronizados (Principle XVI). Revise a linha de badges antes de abrir
o PR: confirme que cada badge existente ainda está correto, e adicione
um novo apenas se sua mudança for um fato genuinamente novo e
relevante que mereça ser sinalizado — nunca um valor escrito à mão que
pode ficar desatualizado (Distribution & Ecosystem Standards).

## Perguntas

Se algo na constitution não estiver claro, isso vale a pena ser
levantado como uma issue por si só — uma regra que ninguém pode seguir
porque é ambígua é um defeito na constitution, não em você.
