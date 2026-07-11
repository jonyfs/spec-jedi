<!-- i18n-sync: source=CONTRIBUTING.md@fa82c3d lang=zh -->
> 🌐 本文档由 AI 辅助翻译。**英文原文为权威版本**（[Principle I](../../../.specify/memory/constitution.md)）；如有出入，以英文为准。查看其他语言：[English](../../../CONTRIBUTING.md) · [中文](../zh/CONTRIBUTING.md) · [हिन्दी](../hi/CONTRIBUTING.md) · [Español](../es/CONTRIBUTING.md) · [Français](../fr/CONTRIBUTING.md) · [العربية](../ar/CONTRIBUTING.md) · [বাংলা](../bn/CONTRIBUTING.md) · [Português](../pt/CONTRIBUTING.md) · [Русский](../ru/CONTRIBUTING.md) · [اردو](../ur/CONTRIBUTING.md) · [Bahasa Indonesia](../id/CONTRIBUTING.md)

# 为 Spec Jedi 做贡献

Spec Jedi 是在自己的[章程](../../../.specify/memory/constitution.md)之下构建的
——一套带版本号的不可动摇规则集，每一次改动，包括这一次，都据此校验。本文档是实际
"我该如何贡献"的操作指南；章程才是每条规则*为什么*存在的权威说明。

## 动手写任何东西之前

1. **阅读章程。** 至少浏览一遍[核心原则](../../../.specify/memory/constitution.md)
   I-XX——大多数贡献问题（"需要测试吗"、"该怎么命名"、"这需要先做研究吗"）在那里
   已经有了答案。
2. **任何新的 `specjedi-*` 技能都需要竞品研究**（Principle II，不可协商）。在提议一个
   新技能之前，先将其与 [github/spec-kit](https://github.com/github/spec-kit) 以及至少
   十个其他公开可用的 SDD 工具进行对比，并指出你的提案相较于它们所提供的、真正的至少
   一项贡献。把这些写在与功能规格并列的 `research.md` 中——参见
   `specs/001-specjedi-pipeline/research.md` 和 `specs/002-specjedi-onboard/research.md`
   了解预期形态。
3. **查阅 `references/skill-roadmap.md`**——你的想法可能已经被列在那里，并附有优先级
   说明；扩展一个已有提案通常比另起一个与之竞争的提案更好。

## 改动如何交付

本项目是基于主干（trunk-based）的（Principle X）：

- `main` 是主干。**任何提交都绝不直接落在 `main` 上。**
- 每一次改动都以自己的短生命周期分支、作为拉取请求（pull request）的形式发出。
- CI（`ci-gate`）在每个 PR 上运行完整的验证 battery——结构性 lint、跨平台检查
  （Linux/macOS/Windows，Principle XIII）。只有当每一项必需检查都变绿，PR 才会合并；
  没有手动覆盖或"强行合并"的路径。
- **仅凭检查通过就自动合并，是仓库所有者自己 PR 的特权。** 如果你是外部贡献者，你的
  PR 除了 `ci-gate` 变绿之外,还需要所有者明确给出的 APPROVED 审查才能合并——确切机制
  见 `.github/workflows/validate.yml` 中的 `owner-gate` 任务。

## 新增或修改一个 `specjedi-*` 技能

新技能和对现有技能的实质性改动都遵循本项目自身的 SDD 流水线——与 Spec Jedi 作为产品
所交付的是同一套（章程的 Development Workflow 小节）：

1. **研究**（Principle II）——见上文。
2. **规格说明（Specify）**——一份带有优先级排序的用户故事、功能需求和可衡量成功标准
   的 `spec.md`。用 `NEEDS CLARIFICATION` 标记真正的歧义，而不是靠猜（Principle V）。
3. **澄清（Clarify）**——在基于猜测做计划之前，解决任何已标记的歧义。
4. **计划（Plan）**——一份带有真实 Constitution Check 关卡的 `plan.md`：如果你的改动
   会违反某条原则，要么简化它，要么在 Complexity Tracking 中明确记录理由，绝不悄悄
   通过关卡。
5. **任务（Tasks）**——一份按依赖排序的 `tasks.md`，凡计划要求写代码之处采用测试先行
   （Principle VI）。
6. **实现（Implement）**——只通过功能分支和 PR（见上文），绝不直接提交到主干。

本仓库中每一个已交付的 `specs/NNN-feature/` 目录都是这一形态的实例——
`specs/001-specjedi-pipeline/` 和 `specs/002-specjedi-onboard/` 是最完整的参考。

## 技能编写与提示工程标准

本仓库中每一个新建或修改的 `SKILL.md` 都必须包含（Principle XIX；完整细节见
[`references/skill-authoring-standard.md`](../../../references/skill-authoring-standard.md)）：

- 清晰的 persona 和 task 陈述。
- 明确定义的输出格式。
- 至少一个完整的"输入 → 输出"实操示例。
- 针对任何非确定性判断的思维链（chain-of-thought）指令。
- 明确的 **Always**/**Never** 准则。
- 可验证的成功标准——可核实的事实，而非感觉。
- 技能自身叙述需要时的受众校准（从新手到资深用户，Principle I）。

## 请求审查前的验证

在打开 PR 之前，本地运行结构性 lint：

```bash
bash scripts/validate.sh      # macOS/Linux
pwsh scripts/validate.ps1     # Windows
```

两者都必须通过——本项目同等支持 Linux、macOS 和 Windows（Principle XIII）；一个只在
一个平台上能用的改动就不算完成。

如果你的技能会产出代码，它还需要一次基于场景的 dry run，确认其 elicitation 问题和
分支逻辑表现如文档所述（Principle IX）——在 PR 描述中说明你实际执行验证了什么。

## 语气与命名

- 产品技能命名为 `specjedi-*`，绝不是 `speckit-*`——后者是本仓库用来构建自身的、
  vendored 的内部自举工具，不是终端用户会安装的东西（Principle XV）。如果这个区分
  不清楚,参见 README 的 "Spec Jedi 如何构建自身" 一节。
- 面向终端用户的叙述（不是生成的 `spec.md`/`plan.md`/`tasks.md` 字段的字面内容）
  使用 Spec Jedi 的星球大战风味语气（Principle XII）——参考词汇表见
  `references/star-wars-lexicon.md`。生成成果物的*内容*保持精确、术语恰当;语气只
  应用于技能自身围绕它的叙述。

## 让 README 保持诚实

如果你的改动新增了一个已交付的技能、一个值得设置徽章的新事实，或者以其他方式改变了
关于本项目为真的事实，请在同一个 PR 中更新 `README.md`——"今天你能获得什么"表格、
Quickstart 编号，以及流水线 Mermaid 图都需要保持同步（Principle XVI）。打开 PR 前
检查徽章行：确认每个既有徽章依然正确显示，只在你的改动是一个真正新的、值得标示的
事实时才添加新徽章——绝不添加一个会过时的手写值（Distribution & Ecosystem
Standards）。

## 问题

如果章程中有任何地方不清楚,那本身就值得作为一个 issue 提出——一条没人能遵守、因为
它本身有歧义的规则，是章程的缺陷，不是你的问题。
