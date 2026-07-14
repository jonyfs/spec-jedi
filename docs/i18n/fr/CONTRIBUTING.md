<!-- i18n-sync: source=CONTRIBUTING.md@1609524 lang=fr -->
> 🌐 Ce document est une traduction assistée par IA. **L'anglais est la source canonique** ([Principle I](../../../.specify/memory/constitution.md)) ; en cas de divergence, l'anglais prévaut. Voir d'autres langues : [English](../../../CONTRIBUTING.md) · [中文](../zh/CONTRIBUTING.md) · [हिन्दी](../hi/CONTRIBUTING.md) · [Español](../es/CONTRIBUTING.md) · [Français](../fr/CONTRIBUTING.md) · [العربية](../ar/CONTRIBUTING.md) · [বাংলা](../bn/CONTRIBUTING.md) · [Português](../pt/CONTRIBUTING.md) · [Русский](../ru/CONTRIBUTING.md) · [اردو](../ur/CONTRIBUTING.md) · [Bahasa Indonesia](../id/CONTRIBUTING.md)

# Contribuer à Spec Jedi

Spec Jedi est construit sous sa propre [constitution](../../../.specify/memory/constitution.md)
— un ensemble versionné de règles non négociables contre lequel chaque changement, y
compris celui-ci, est vérifié. Ce document est le compagnon pratique du "comment est-ce
que je contribue réellement" ; la constitution est la déclaration définitive du
*pourquoi* chaque règle existe.

## Avant d'écrire quoi que ce soit

1. **Lisez la constitution.** Au minimum, parcourez les
   [Principes Fondamentaux](../../../.specify/memory/constitution.md) I-XX — la plupart
   des questions de contribution ("ai-je besoin de tests", "comment cela devrait-il être
   nommé", "cela nécessite-t-il d'abord une recherche") y trouvent déjà réponse.
2. **La recherche concurrentielle est requise pour toute nouvelle skill `specjedi-*`**
   (Principle II, non négociable). Avant de proposer une nouvelle skill, comparez-la à
   [github/spec-kit](https://github.com/github/spec-kit) et à au moins dix autres outils
   SDD publiquement disponibles, et nommez au moins une contribution authentique que
   votre proposition apporte au-delà de ce que l'un d'eux offre déjà. Rédigez ceci dans
   un `research.md` aux côtés de la spécification de la fonctionnalité — voir
   `specs/001-specjedi-pipeline/research.md` et `specs/002-specjedi-onboard/research.md`
   pour la forme attendue.
3. **Consultez `references/skill-roadmap.md`** — votre idée y est peut-être déjà
   délimitée avec des notes de priorisation ; étendre une proposition existante est
   généralement préférable à en ouvrir une concurrente.

## Comment les changements sont livrés

Ce projet est basé sur le tronc (trunk-based) (Principle X) :

- `main` est le tronc. **Aucun commit n'atterrit jamais directement sur `main`.**
- Chaque changement part sur sa propre branche de courte durée sous forme de pull
  request.
- Le CI (`ci-gate`) exécute toute la batterie de validation — lint structurel,
  vérifications multiplateformes (Linux/macOS/Windows, Principle XIII) — sur chaque PR.
  Une PR ne fusionne qu'une fois chaque vérification requise au vert ; il n'y a pas de
  contournement manuel ni de chemin "fusionner quand même".
- **L'auto-fusion basée uniquement sur les vérifications est un privilège des PR du
  propriétaire du dépôt lui-même.** Si vous êtes un contributeur externe, votre PR a
  besoin d'une revue APPROVED explicite du propriétaire en plus d'un `ci-gate` au vert
  avant de fusionner — voir le job `owner-gate` dans
  `.github/workflows/validate.yml` pour le mécanisme exact.

![une silhouette solitaire à une bifurcation d'un chemin de pierre, un sentier éclairé par de chaleureuses lanternes montant vers le haut, l'autre s'estompant dans l'ombre froide](../../comic/letter-path.jpg)

Ce n'est pas de la bureaucratie pour elle-même — c'est le bon côté de la
Force, mécanisé : le genre de discipline qui tient même quand personne
ne regarde, parce que la constitution regarde à sa place.

## Versionnage et releases

Spec Jedi suit le [Versionnage Sémantique](https://semver.org/), limité
au contrat public du paquet de skills : casser le comportement d'une
skill est MAJOR, une nouvelle skill ou une capacité additive est MINOR,
les corrections et la documentation sont PATCH. La politique complète
vit dans le [Principle XI](.specify/memory/constitution.md).

Personne ne coupe une release en silence ici — le projet suggère
simplement quand une release est justifiée et laisse la décision réelle
à un humain :

```bash
# Linux / macOS / Windows (WSL ou Git Bash)
./scripts/suggest-release.sh
```

```powershell
# Windows (PowerShell natif)
./scripts/suggest-release.ps1
```

Ceci inspecte les commits depuis le dernier tag et recommande une
prochaine version. Il ne tague ni ne publie jamais rien lui-même —
couper effectivement une release reste toujours une étape délibérée,
dirigée par le mainteneur, à chaque fois.

## Ajouter ou modifier une skill `specjedi-*`

Les nouvelles skills et les changements substantiels aux skills existantes suivent le
propre pipeline SDD de ce projet — le même que celui que Spec Jedi livre en tant que
produit (section Development Workflow de la constitution) :

1. **Recherche** (Principle II) — voir ci-dessus.
2. **Spécifier** — un `spec.md` avec des user stories priorisées, des exigences
   fonctionnelles, et des critères de succès mesurables. Marquez l'ambiguïté authentique
   avec `NEEDS CLARIFICATION` plutôt que de deviner (Principle V).
3. **Clarifier** — résolvez toute ambiguïté marquée avant de planifier sur une
   supposition.
4. **Planifier** — un `plan.md` avec une véritable porte Constitution Check : si votre
   changement violerait un principe, soit simplifiez-le, soit consignez explicitement la
   justification dans Complexity Tracking, ne passez jamais la porte silencieusement.
5. **Tâches** — un `tasks.md` ordonné par dépendances, tests d'abord là où le plan
   appelle du code (Principle VI).
6. **Implémenter** — uniquement via une branche de fonctionnalité et une PR (voir
   ci-dessus), jamais un commit direct sur le tronc.

Chaque répertoire `specs/NNN-feature/` livré dans ce dépôt est un exemple fonctionnel de
cette forme — `specs/001-specjedi-pipeline/` et `specs/002-specjedi-onboard/` sont les
références les plus complètes.

## Standard de Rédaction de Skills et de Prompt Engineering

Chaque `SKILL.md` de ce dépôt, nouveau ou modifié, DOIT inclure (Principle XIX ; détail
complet dans
[`references/skill-authoring-standard.md`](../../../references/skill-authoring-standard.md)) :

- Un persona clair et une déclaration de tâche.
- Un format de sortie défini.
- Au moins un exemple complet "entrée → sortie" travaillé.
- Une instruction de chaîne de raisonnement (chain-of-thought) pour toute décision de
  jugement non déterministe.
- Des garde-fous explicites **Always** / **Never**.
- Des critères de succès vérifiables — des faits contrôlables, pas des impressions.
- Une calibration selon l'audience là où la propre narration de la skill en a besoin
  (du débutant à l'avancé, Principle I).

## Validation avant de demander une revue

Exécutez le lint structurel localement avant d'ouvrir une PR :

```bash
bash scripts/validate.sh      # macOS/Linux
pwsh scripts/validate.ps1     # Windows
```

Les deux doivent passer — ce projet supporte Linux, macOS et Windows à égalité
(Principle XIII) ; un changement qui ne fonctionne que sur une plateforme n'est pas
terminé.

Si votre skill produit du code, elle a aussi besoin d'un dry run basé sur des scénarios
confirmant que ses questions d'élicitation et sa logique de branchement se comportent
comme documenté (Principle IX) — décrivez ce que vous avez exercé dans la description
de la PR.

## Voix et nomenclature

- Les skills de produit sont nommées `specjedi-*`, jamais `speckit-*` — cette dernière
  est l'outillage interne de bootstrap distribué (vendored) que ce dépôt utilise pour se
  construire lui-même, pas quelque chose que les utilisateurs finaux installent
  (Principle XV). Voir la section "Comment Spec Jedi se construit lui-même" du README si
  cette distinction n'est pas claire.
- La narration destinée à l'utilisateur final (pas le contenu littéral des champs
  générés de `spec.md`/`plan.md`/`tasks.md`) utilise la voix à saveur Star Wars propre à
  Spec Jedi (Principle XII) — voir `references/star-wars-lexicon.md` pour le lexique de
  référence. Le *contenu* de l'artefact généré reste précis et approprié en jargon ; la
  voix s'applique à la narration de la skill elle-même autour de lui.

## Garder le README honnête

Si votre changement ajoute une skill livrée, un nouveau fait digne d'un badge, ou change
autrement ce qui est vrai à propos du projet, mettez à jour `README.md` dans la même
PR — le tableau "Ce que vous obtenez aujourd'hui", la numérotation du Quickstart, et le
diagramme Mermaid du pipeline doivent tous rester synchronisés (Principle XVI). Passez
en revue la ligne de badges avant d'ouvrir la PR : confirmez que chaque badge existant
s'affiche toujours correctement, et n'ajoutez-en un nouveau que si votre changement est
un fait authentiquement nouveau et pertinent qui mérite d'être signalé — jamais une
valeur écrite à la main qui peut devenir obsolète (Distribution & Ecosystem Standards).

## Questions

Si quelque chose dans la constitution n'est pas clair, cela vaut la peine d'être
soulevé comme un issue à part entière — une règle que personne ne peut suivre parce
qu'elle est ambiguë est un défaut de la constitution, pas de vous.
