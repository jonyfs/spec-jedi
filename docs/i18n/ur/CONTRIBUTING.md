<!-- i18n-sync: source=CONTRIBUTING.md@fa82c3d lang=ur -->
> 🌐 یہ دستاویز AI کی مدد سے ترجمہ کی گئی ہے۔ **انگریزی مستند ماخذ ہے**
> ([Principle I](../../../.specify/memory/constitution.md))؛ کسی بھی
> فرق کی صورت میں انگریزی کو ترجیح حاصل ہوگی۔ دیگر زبانیں دیکھیں:
> [English](../../../CONTRIBUTING.md) · [中文](../zh/CONTRIBUTING.md) ·
> [हिन्दी](../hi/CONTRIBUTING.md) · [Español](../es/CONTRIBUTING.md) ·
> [Français](../fr/CONTRIBUTING.md) · [العربية](../ar/CONTRIBUTING.md) ·
> [বাংলা](../bn/CONTRIBUTING.md) · [Português](../pt/CONTRIBUTING.md) ·
> [Русский](../ru/CONTRIBUTING.md) · [اردو](../ur/CONTRIBUTING.md) ·
> [Bahasa Indonesia](../id/CONTRIBUTING.md)

# Spec Jedi میں تعاون کرنا

Spec Jedi اپنے ہی [constitution](../../../.specify/memory/constitution.md)
کے تحت بنایا گیا ہے — ناقابلِ مصالحت اصولوں کا ایک versioned سیٹ جس کے
خلاف ہر تبدیلی، یہ تبدیلی بھی شامل ہے، verify کی جاتی ہے۔ یہ دستاویز
عملی "میں واقعی کیسے تعاون کروں" ساتھی ہے؛ constitution ہر اصول کے
وجود کی *کیوں* کا حتمی بیان ہے۔

## کچھ لکھنے سے پہلے

1. **Constitution پڑھیں۔** کم از کم،
   [Core Principles](../../../.specify/memory/constitution.md) I-XX
   دیکھ لیں — زیادہ تر contribution سے متعلق سوالات ("کیا مجھے tests
   چاہیے"، "اسے کیسے نام دیا جانا چاہیے"، "کیا اس کے لیے پہلے research
   چاہیے") کے جوابات وہاں پہلے سے موجود ہیں۔
2. **کسی بھی نئی `specjedi-*` skill کے لیے competitive research لازمی
   ہے** (Principle II, ناقابلِ مذاکرات)۔ کوئی نئی skill تجویز کرنے سے
   پہلے، اسے [github/spec-kit](https://github.com/github/spec-kit) اور
   کم از کم دس دیگر عوامی طور پر دستیاب SDD tools کے ساتھ benchmark
   کریں، اور کم از کم ایک حقیقی contribution بتائیں جو آپ کی تجویز ان
   میں سے کسی کے پہلے سے پیش کردہ سے آگے دیتی ہے۔ اسے feature spec کے
   ساتھ ایک `research.md` میں لکھیں — متوقع شکل کے لیے دیکھیں
   `specs/001-specjedi-pipeline/research.md` اور
   `specs/002-specjedi-onboard/research.md`۔
3. **`references/skill-roadmap.md` چیک کریں** — آپ کا idea شاید پہلے
   سے ہی وہاں prioritization notes کے ساتھ scoped ہو؛ ایک موجودہ
   proposal کو بڑھانا عام طور پر ایک نیا مقابل proposal کھولنے سے بہتر
   ہوتا ہے۔

## تبدیلیاں کیسے ship ہوتی ہیں

یہ project trunk-based ہے (Principle X):

- `main` trunk ہے۔ **کوئی بھی commit کبھی سیدھا `main` پر نہیں جاتا۔**
- ہر تبدیلی pull request کے طور پر اپنی short-lived branch پر جاتی ہے۔
- CI (`ci-gate`) ہر PR پر مکمل validation battery چلاتا ہے — structural
  lint، cross-platform checks (Linux/macOS/Windows, Principle XIII)۔
  PR تبھی merge ہوتا ہے جب ہر required check green ہو؛ کوئی manual
  override یا "پھر بھی merge کرو" راستہ نہیں ہے۔
- **صرف checks کی بنیاد پر auto-merge repository owner کے اپنے PRs کا
  استحقاق ہے۔** اگر آپ بیرونی contributor ہیں، تو merge ہونے سے پہلے
  آپ کے PR کو green `ci-gate` کے علاوہ owner سے ایک واضح APPROVED
  review چاہیے — درست mechanism کے لیے
  `.github/workflows/validate.yml` میں `owner-gate` job دیکھیں۔

## کسی `specjedi-*` skill کو شامل کرنا یا تبدیل کرنا

نئی skills اور موجودہ skills میں اہم تبدیلیاں اس project کی اپنی SDD
pipeline کی پیروی کرتی ہیں — وہی جسے Spec Jedi product کے طور پر ship
کرتا ہے (constitution کا Development Workflow section):

1. **Research** (Principle II) — اوپر دیکھیں۔
2. **Specify** — prioritized user stories, functional requirements، اور
   measurable success criteria والا ایک `spec.md`۔ اندازہ لگانے کے
   بجائے حقیقی ambiguity کو `NEEDS CLARIFICATION` سے نشان زد کریں
   (Principle V)۔
3. **Clarify** — کسی اندازے کی بنیاد پر plan بنانے سے پہلے کسی بھی
   نشان زد ambiguity کو حل کریں۔
4. **Plan** — ایک حقیقی Constitution Check gate والا `plan.md`: اگر
   آپ کی تبدیلی کسی principle کی خلاف ورزی کرتی ہے، تو یا تو اسے
   simplify کریں یا Complexity Tracking میں واضح طور پر justification
   درج کریں، gate کو کبھی خاموشی سے pass نہ ہونے دیں۔
5. **Tasks** — dependency-ordered `tasks.md`، جہاں plan code کی مانگ
   کرتا ہے وہاں test-first (Principle VI)۔
6. **Implement** — صرف ایک feature branch اور PR کے ذریعے (اوپر
   دیکھیں)، کبھی trunk پر سیدھا commit نہیں۔

اس repository میں shipped ہر `specs/NNN-feature/` directory اسی شکل کی
ایک عملی مثال ہے — `specs/001-specjedi-pipeline/` اور
`specs/002-specjedi-onboard/` سب سے مکمل references ہیں۔

## Skill Authoring اور Prompt Engineering Standard

اس repository میں ہر `SKILL.md`، نیا ہو یا modified، ان کو شامل کرنا
لازمی ہے (Principle XIX؛ مکمل تفصیل
[`references/skill-authoring-standard.md`](../../../references/skill-authoring-standard.md)
میں):

- واضح persona اور task بیان۔
- ایک defined output format۔
- کم از کم ایک مکمل "input → output" worked example۔
- کسی بھی non-deterministic judgment call کے لیے chain-of-thought
  instruction۔
- واضح **Always** / **Never** guardrails۔
- Verifiable success criteria — verify کیے جا سکنے والے حقائق، feelings
  نہیں۔
- جہاں skill کی اپنی narration کو اس کی ضرورت ہو وہاں audience
  calibration (beginner سے لے کر advanced تک، Principle I)۔

## Review کی درخواست سے پہلے Validation

PR کھولنے سے پہلے structural lint کو locally چلائیں:

```bash
bash scripts/validate.sh      # macOS/Linux
pwsh scripts/validate.ps1     # Windows
```

دونوں pass ہونے چاہئیں — یہ project Linux، macOS، اور Windows کو یکساں
طور پر support کرتا ہے (Principle XIII)؛ ایسی تبدیلی جو صرف ایک
platform پر کام کرتی ہو، مکمل نہیں مانی جاتی۔

اگر آپ کی skill code produce کرتی ہے، تو اسے یہ تصدیق کرنے کے لیے ایک
scenario-based dry run بھی چاہیے کہ اس کے elicitation سوالات اور
branching logic دستاویز کے مطابق برتاؤ کرتے ہیں (Principle IX) — PR
description میں بتائیں کہ آپ نے کیا exercise کیا۔

## آواز اور نامکرن

- Product skills کا نام `specjedi-*` رکھا جاتا ہے، کبھی `speckit-*`
  نہیں — بعد والا vendored internal bootstrap tooling ہے جسے یہ
  repository خود کو بنانے کے لیے استعمال کرتا ہے، یہ وہ چیز نہیں جسے
  end users install کرتے ہیں (Principle XV)۔ اگر یہ فرق واضح نہیں ہے
  تو README کا "Spec Jedi کیسے خود کو بناتا ہے" section دیکھیں۔
- End-user-facing narration (generated `spec.md`/`plan.md`/`tasks.md`
  fields کا لفظی مواد نہیں) Spec Jedi کی Star Wars-flavored آواز
  استعمال کرتی ہے (Principle XII) — reference lexicon کے لیے
  `references/star-wars-lexicon.md` دیکھیں۔ Generated artifact کا
  *مواد* درست اور jargon-appropriate رہتا ہے؛ آواز اس کے اردگرد کی
  skill کی اپنی narration پر لاگو ہوتی ہے۔

## README کو honest رکھنا

اگر آپ کی تبدیلی ایک shipped skill، کوئی نیا badge-worthy fact شامل
کرتی ہے، یا project کے بارے میں جو سچ ہے اسے کسی اور طرح بدلتی ہے، تو
اسی PR میں `README.md` کو update کریں — "آج آپ کو کیا ملتا ہے" table،
Quickstart numbering، اور pipeline Mermaid diagram، سبھی کو sync میں
رہنا چاہیے (Principle XVI)۔ PR کھولنے سے پہلے badge row کی جائزہ لیں:
تصدیق کریں کہ ہر موجودہ badge اب بھی صحیح دکھتا ہے، اور نیا badge تبھی
شامل کریں جب آپ کی تبدیلی ایک genuinely نیا، relevant fact ہو جو سگنل
کیے جانے کے لائق ہو — کبھی کوئی ایسا hand-typed value نہیں جو stale ہو
سکتا ہو (Distribution & Ecosystem Standards)۔

## سوالات

اگر constitution میں کچھ واضح نہیں ہے، تو اسے اپنے آپ میں ایک issue کے
طور پر اٹھانا درست ہے — ایسا اصول جسے کوئی پیروی نہیں کر سکتا کیونکہ یہ
مبہم ہے، constitution کی خامی ہے، آپ کی نہیں۔
