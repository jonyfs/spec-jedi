<!-- i18n-sync: source=CONTRIBUTING.md@01f83f5 lang=hi -->
> 🌐 यह दस्तावेज़ AI-सहायता प्राप्त अनुवाद है। **अंग्रेज़ी मूल स्रोत है** ([Principle I](../../../.specify/memory/constitution.md))；किसी भी विरोधाभास की स्थिति में अंग्रेज़ी संस्करण मान्य होगा। अन्य भाषाएँ देखें: [English](../../../CONTRIBUTING.md) · [中文](../zh/CONTRIBUTING.md) · [हिन्दी](../hi/CONTRIBUTING.md) · [Español](../es/CONTRIBUTING.md) · [Français](../fr/CONTRIBUTING.md) · [العربية](../ar/CONTRIBUTING.md) · [বাংলা](../bn/CONTRIBUTING.md) · [Português](../pt/CONTRIBUTING.md) · [Русский](../ru/CONTRIBUTING.md) · [اردو](../ur/CONTRIBUTING.md) · [Bahasa Indonesia](../id/CONTRIBUTING.md)

# Spec Jedi में योगदान देना

Spec Jedi अपने ही [constitution](../../../.specify/memory/constitution.md) के अंतर्गत
बनाया गया है — गैर-परक्राम्य नियमों का एक versioned सेट जिसके विरुद्ध हर बदलाव, यह
बदलाव भी शामिल है, जाँचा जाता है। यह दस्तावेज़ व्यावहारिक "मैं वास्तव में योगदान कैसे
दूँ" साथी है; constitution हर नियम के अस्तित्व के *क्यों* का निश्चायक कथन है।

## कुछ भी लिखने से पहले

1. **Constitution पढ़ें।** कम से कम,
   [Core Principles](../../../.specify/memory/constitution.md) I-XX को सरसरी तौर पर
   देखें — अधिकतर contribution संबंधी सवालों ("क्या मुझे tests चाहिए", "इसे कैसे नाम
   दिया जाना चाहिए", "क्या इसके लिए पहले research चाहिए") के जवाब वहाँ पहले से मौजूद
   हैं।
2. **किसी भी नई `specjedi-*` skill के लिए competitive research आवश्यक है**
   (Principle II, non-negotiable)। कोई नई skill प्रस्तावित करने से पहले, इसे
   [github/spec-kit](https://github.com/github/spec-kit) और कम से कम दस अन्य publicly
   available SDD tools के साथ benchmark करें, और कम से कम एक genuine contribution बताएँ
   जो आपका proposal उनमें से किसी के पहले से दिए जा रहे से आगे जाकर देता है। इसे feature
   spec के साथ एक `research.md` में लिखें — अपेक्षित आकार के लिए देखें
   `specs/001-specjedi-pipeline/research.md` और `specs/002-specjedi-onboard/research.md`।
3. **`references/skill-roadmap.md` देखें** — आपका idea शायद पहले से ही वहाँ
   prioritization notes के साथ scoped हो; किसी मौजूदा proposal को बढ़ाना आमतौर पर नया
   प्रतिस्पर्धी proposal खोलने से बेहतर होता है।

## बदलाव कैसे ship होते हैं

यह project trunk-based है (Principle X):

- `main` trunk है। **कोई भी commit कभी सीधे `main` पर नहीं जाता।**
- हर बदलाव pull request के रूप में अपनी short-lived branch पर जाता है।
- CI (`ci-gate`) हर PR पर पूरी validation battery चलाता है — structural lint,
  cross-platform checks (Linux/macOS/Windows, Principle XIII)। PR तभी merge होता है जब
  हर required check green हो; कोई manual override या "फिर भी merge करो" रास्ता नहीं है।
- **सिर्फ़ checks के आधार पर auto-merge repository owner के अपने PRs का विशेषाधिकार
  है।** अगर आप बाहरी योगदानकर्ता हैं, तो merge होने से पहले आपके PR को green `ci-gate`
  के अलावा owner से एक स्पष्ट APPROVED review चाहिए — exact mechanism के लिए
  `.github/workflows/validate.yml` में `owner-gate` job देखें।

## किसी `specjedi-*` skill को जोड़ना या बदलना

नई skills और मौजूदा skills में substantial बदलाव इस project की अपनी SDD pipeline का
पालन करते हैं — वही जिसे Spec Jedi product के रूप में ship करता है (constitution का
Development Workflow section):

1. **Research** (Principle II) — ऊपर देखें।
2. **Specify** — prioritized user stories, functional requirements, और measurable
   success criteria वाला एक `spec.md`। अनुमान लगाने के बजाय वास्तविक ambiguity को
   `NEEDS CLARIFICATION` से चिह्नित करें (Principle V)।
3. **Clarify** — किसी अनुमान के आधार पर plan बनाने से पहले किसी भी चिह्नित ambiguity को
   हल करें।
4. **Plan** — एक वास्तविक Constitution Check gate वाला `plan.md`: अगर आपका बदलाव किसी
   principle का उल्लंघन करता है, तो या तो उसे simplify करें या Complexity Tracking में
   स्पष्ट रूप से justification दर्ज करें, gate को कभी चुपचाप pass न होने दें।
5. **Tasks** — dependency-ordered `tasks.md`, जहाँ plan code की माँग करता है वहाँ
   test-first (Principle VI)।
6. **Implement** — केवल एक feature branch और PR के माध्यम से (ऊपर देखें), कभी trunk पर
   सीधा commit नहीं।

इस repository में shipped हर `specs/NNN-feature/` directory इसी आकार का एक worked
example है — `specs/001-specjedi-pipeline/` और `specs/002-specjedi-onboard/` सबसे पूर्ण
references हैं।

## Skill Authoring और Prompt Engineering Standard

इस repository में हर `SKILL.md`, नया हो या modified, इन्हें शामिल करना ही होगा
(Principle XIX; पूरा विवरण
[`references/skill-authoring-standard.md`](../../../references/skill-authoring-standard.md)
में):

- स्पष्ट persona और task कथन।
- एक defined output format।
- कम से कम एक पूरा "input → output" worked example।
- किसी भी non-deterministic judgment call के लिए chain-of-thought instruction।
- स्पष्ट **Always** / **Never** guardrails।
- Verifiable success criteria — verify किए जा सकने वाले तथ्य, feelings नहीं।
- जहाँ skill की अपनी narration को इसकी ज़रूरत हो वहाँ audience calibration (beginner से
  लेकर advanced तक, Principle I)।

## Review का अनुरोध करने से पहले Validation

PR खोलने से पहले structural lint को locally चलाएँ:

```bash
bash scripts/validate.sh      # macOS/Linux
pwsh scripts/validate.ps1     # Windows
```

दोनों pass होने चाहिए — यह project Linux, macOS, और Windows को समान रूप से support
करता है (Principle XIII); ऐसा बदलाव जो केवल एक platform पर काम करता हो, पूरा नहीं
माना जाता।

अगर आपकी skill code produce करती है, तो इसे यह पुष्टि करने के लिए एक scenario-based dry
run भी चाहिए कि इसके elicitation प्रश्न और branching logic दस्तावेज़ के अनुसार व्यवहार
करते हैं (Principle IX) — PR description में बताएँ कि आपने क्या exercise किया।

## आवाज़ और नामकरण

- Product skills का नाम `specjedi-*` रखा जाता है, कभी `speckit-*` नहीं — बाद वाला
  vendored internal bootstrap tooling है जिसे यह repository खुद को बनाने के लिए
  इस्तेमाल करता है, यह वह चीज़ नहीं जिसे end users install करते हैं (Principle XV)। अगर
  यह अंतर स्पष्ट नहीं है तो README का "Spec Jedi कैसे खुद को बनाता है" section देखें।
- End-user-facing narration (generated `spec.md`/`plan.md`/`tasks.md` fields के literal
  content नहीं) Spec Jedi की Star Wars-flavored आवाज़ का इस्तेमाल करती है
  (Principle XII) — reference lexicon के लिए `references/star-wars-lexicon.md` देखें।
  Generated artifact की *content* सटीक और jargon-appropriate बनी रहती है; आवाज़ उसके
  आसपास की skill की अपनी narration पर लागू होती है।

## README को honest रखना

अगर आपका बदलाव एक shipped skill, कोई नया badge-worthy fact जोड़ता है, या project के बारे
में जो सच है उसे किसी और तरह बदलता है, तो उसी PR में `README.md` को update करें — "आज
आपको क्या मिलता है" table, Quickstart numbering, और pipeline Mermaid diagram, सभी को
sync में रहना चाहिए (Principle XVI)। PR खोलने से पहले badge row की समीक्षा करें: पुष्टि
करें कि हर मौजूदा badge अभी भी सही दिखता है, और नया badge तभी जोड़ें जब आपका बदलाव एक
genuinely नया, relevant तथ्य हो जो सिग्नल किए जाने लायक हो — कभी कोई ऐसा hand-typed
value नहीं जो stale हो सकता हो (Distribution & Ecosystem Standards)।

## प्रश्न

अगर constitution में कुछ स्पष्ट नहीं है, तो इसे अपने आप में एक issue के रूप में उठाना
सही है — ऐसा नियम जिसे कोई पालन नहीं कर सकता क्योंकि यह अस्पष्ट है, constitution की
खामी है, आपकी नहीं।
