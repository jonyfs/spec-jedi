<!-- i18n-sync: source=README.md@2a01f98 lang=zh -->
> 🌐 本文档由 AI 辅助翻译。**英文原文为权威版本**（[Principle I](../../../.specify/memory/constitution.md)）；如有出入，以英文为准。查看其他语言：[English](../../../README.md) · [中文](../zh/README.md) · [हिन्दी](../hi/README.md) · [Español](../es/README.md) · [Français](../fr/README.md) · [العربية](../ar/README.md) · [বাংলা](../bn/README.md) · [Português](../pt/README.md) · [Русский](../ru/README.md) · [اردو](../ur/README.md) · [Bahasa Indonesia](../id/README.md)

# Spec Jedi

[![CI](https://img.shields.io/github/actions/workflow/status/jonyfs/spec-jedi/validate.yml?branch=main&label=ci-gate&logo=githubactions&logoColor=white)](https://github.com/jonyfs/spec-jedi/actions/workflows/validate.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../../LICENSE)
[![Constitution](https://img.shields.io/badge/dynamic/regex?url=https%3A%2F%2Fraw.githubusercontent.com%2Fjonyfs%2Fspec-jedi%2Fmain%2F.specify%2Fmemory%2Fconstitution.md&search=%5C%2A%5C%2AVersion%5C%2A%5C%2A%3A%5Cs%2A%28%5B%5Cd.%5D%2B%29&replace=%241&label=constitution&color=7c3aed)](../../../.specify/memory/constitution.md)
[![Pipeline](https://img.shields.io/badge/specjedi_pipeline-9%2F9_shipped-success)](#spec-jedi-如何实现-sdd)
[![Skills](https://img.shields.io/badge/specjedi_skills-30_shipped-success)](#spec-jedi-如何实现-sdd)
[![Roadmap](https://img.shields.io/badge/roadmap_backlog-12%2F12_shipped-success)](../../../references/skill-roadmap.md)
[![Installer](https://img.shields.io/badge/installer-one--command-blueviolet)](#安装)
[![Languages](https://img.shields.io/badge/docs-11_languages-informational)](../../../docs/i18n/)
[![PRs](https://img.shields.io/badge/pull_requests-auto--merged_on_green-brightgreen)](../../../.specify/memory/constitution.md)
[![Last commit](https://img.shields.io/github/last-commit/jonyfs/spec-jedi)](https://github.com/jonyfs/spec-jedi/commits/main)

> *"先有规格，后有代码。这才是原力之道。"* —— 一位智者，大概是这么说的。

![一卷磨损的羊皮卷和一支发光的羽毛笔，放在寂静天文台的石桌上，星光透过高高的窗户洒落](../../comic/letter-open.jpg)

**一封信，来自一位大师，写给下一个接过这卷羊皮卷的人：**

大多数超出自身计划范围的项目都有着同一个根本原因：先有代码，后有解释——而这个
"后"从来没有真正到来过。接下来要讲的，正是把这个顺序颠倒过来的实践，以及为实践
它而构建的具体项目。

*（非官方、粉丝向的品牌演绎——Spec Jedi 与 Lucasfilm/Disney 没有从属、背书或赞助关系。愿原力与你同在。🌌）*

## 什么是规格驱动开发？

大多数人用 AI 编码智能体构建软件的默认方式是这样的：在聊天中描述你想要什么，
智能体写出代码，你读代码来判断它是否做到了你的本意，然后修正它，如此往复。
智能体对"你的本意"的理解只存在于对话之中——从未被记录为一份持久、可审阅的成果
物。由此产生两种失败模式：歧义靠猜测来解决，而不是被摆到明面上做决定；而且没有
什么能在对话结束后留存下来——关掉聊天窗口，就丢失了推理过程。

规格驱动开发（Spec-Driven Development, SDD）把这个顺序颠倒过来。在任何一行代码
存在之前，先把要构建什么、为什么要构建写下来，形成四份结构化、可审阅的文档：由
`specjedi-constitution` 撰写的**章程** 📜（项目不可动摇的规则）、由
`specjedi-specify` 撰写的**规格说明** 🎯（做什么、为了谁）、由 `specjedi-plan`
撰写的**计划** 🛠️（技术上如何实现），以及由 `specjedi-tasks` 撰写的**任务清单**
✅（有序的执行步骤）。代码是*依据*这四份成果物生成的，而不是反过来。完整解释，
不含任何 Spec Jedi 自身品牌色彩：
[`references/what-is-sdd.md`](../../../references/what-is-sdd.md)。

```mermaid
flowchart TD
    Const["📜 constitution.md<br/>the project's non-negotiable rules"] --> Core["🛠️ Core Pipeline<br/>9 skills"]
    Const --> Onboard["🌱 Onboarding & Guidance<br/>4 skills"]
    Const --> Quality["🛡️ Quality & Review<br/>6 skills"]
    Const --> Meta["📊 Meta & Tooling<br/>11 skills"]
```

接下来的一切都依据章程校验自身，绝不是反过来。改变一条规则，每个技能都会在下一次
运行时感知到。

## Spec Jedi 如何实现 SDD

Spec Jedi 是 [spec-kit](https://github.com/github/spec-kit) 的**竞争者**
（[Principle XV](../../../.specify/memory/constitution.md)），以 `specjedi-*`
技能集的形式构建，项目可以将其与 spec-kit 自身的 `speckit-*` 命令并行安装——或者
用它取而代之——并且全部二十种目标编码智能体都已得到支持（见下方[安装](#安装)）。
完整的 `specjedi-*` SDD 流水线——从章程到收敛——早已全部交付：全部 9 个阶段，
每一个都建立在真实的竞品研究之上，然后才动笔写下第一行代码
（[research.md](../../../specs/001-specjedi-pipeline/research.md)，Principle II）。

以上每一项 SDD 活动都对应着一个真实、当前已经交付的 `specjedi-*` 技能，而不是一种
愿景：`specjedi-constitution` 建立规则，`specjedi-specify` 把想法转化为
`spec.md`，`specjedi-clarify` 解决被标记的歧义，`specjedi-plan` 和
`specjedi-tasks` 产出技术计划和任务拆解，而 `specjedi-implement`（或面向小型、
已充分理解改动的 `specjedi-quick`）则以测试先行的方式执行它，且只通过功能分支和
拉取请求进行。今天总共有三十个技能可用，分布在四大门类——完整目录、两张图表以及
23 步走查指南都收录在
[`references/quickstart-guide.md`](../../../references/quickstart-guide.md)；
完整的"活动 → 技能"对照表，包括超越通用 SDD 实践的三项真实贡献，收录在
[`references/specjedi-and-sdd.md`](../../../references/specjedi-and-sdd.md)。

### `specjedi-*` 对比 `speckit-*`：用数据说话

一份基于证据、逐条命令对比的评测——
[`specs/044-speckit-parity-audit/PARITY-LEDGER.md`](../../../specs/044-speckit-parity-audit/PARITY-LEDGER.md)
——按照实际描述的行为，而不是名称相似度，核对了 `speckit-*` 全部 11 个流水线命令
与其对应的 `specjedi-*` 命令：

- **11 项中有 8 项**达到完全对等——同样的任务，同样的输入/输出。
- **11 项中有 1 项**（`specjedi-implement` 对比 `speckit-implement`）是一处更优的
  分歧：`specjedi-implement` 要求只通过功能分支和拉取请求提交，绝不直接提交到主干
  分支；而 `speckit-implement` 自身的说明完全没有涉及任何 git 分支或提交纪律。
- **11 项中有 2 项**没有对应的 `specjedi-*` 命令——但这两项都已经解决，不是尚待
  填补的缺口：GitHub issue 任务转换（本项目自身真实历史上从未使用过）以及一个持久
  化的"当前计划"指针（已被 `specjedi-status` 的零并行追踪设计以及 Constitution
  Principle XXI 自身的会话开始状态重新呈现机制所取代）。
- 已交付的 **30 个 `specjedi-*` 技能中有 21 个**完全没有对应的 `speckit-*` 命令——
  `specjedi-catalog-audit`、`specjedi-chain`、`specjedi-constitution-audit`、
  `specjedi-diagram`、`specjedi-docs`、`specjedi-explain`、
  `specjedi-find-skills`、`specjedi-govcheck`、`specjedi-master`、
  `specjedi-migrate`、`specjedi-new-skill`、`specjedi-onboard`、
  `specjedi-parallel`、`specjedi-quick`、`specjedi-release`、`specjedi-retro`、
  `specjedi-security`、`specjedi-skill-review`、`specjedi-status`、
  `specjedi-tokencheck`，以及 `specjedi-worktree`——是真正新增的能力，而不是对
  既有流水线的重新表述。

好奇接下来还有什么？
[`references/skill-roadmap.md`](../../../references/skill-roadmap.md)
追踪了核心流水线之外还提议了哪些内容——这是一份*额外*想法的储备清单，不是核心
流水线本身的缺口。每一项在被构建前仍需要各自真实的研究阶段；这里没有任何东西是
靠直觉交付的。

## 适合谁使用

厌倦了每次会话都要重新解释同一个项目背景。厌倦了看着智能体悄悄重新发明一个团队
三周前就已经做出并放弃的决定，只因为没有任何地方把它写下来、让智能体能找到。无
论是一个人还是一整个团队，想让所有智能体表现一致——任何希望规格、计划和任务成为
真实的、带版本管理的文件，而不是关掉窗口就消失的聊天消息的人，都是这里所面向的
读者。

## Spec Jedi 如何以漫画形式构建*自身*

> ⚠️ **本节展示的是本项目自身真实的开发流水线在实际运行**——下面的
> `specjedi-*` 命令与前文描述的产品能力完全相同，只是被用在了 Spec Jedi 自己身上。
> 在功能 048（2026-07-18）之前，本项目一直用 spec-kit 自身、vendored 的
> `speckit-*` 命令自举构建自己（就像任何竞争者在构建替代品时都可能借用的"用旧
> 编译器引导新编译器"模式），直到自己的 `specjedi-*` 流水线足够完善、可以接管
> 为止。那个自举阶段已经结束——完整政策及这次迁移完成的内容见
> [Principle XV](../../../.specify/memory/constitution.md)。
>
> 另外说明一下格式：下面的分镜把文字加表情符号的对话与原创插画结合在一起——绝不
> 是真正的星球大战图像（角色、飞船、logo），那些属于 Lucasfilm/Disney 的知识产权。
> 本项目自己的
> [Principle XII](../../../.specify/memory/constitution.md) 承诺采用原创的视觉
> 身份，星球大战相关内容只使用文字引用，绝不复制受版权保护的美术作品，也绝不制作
> 会让人联想到该系列标志性视觉符号的美术作品。所以：故事情节是真的，美术是原创
> 的，文字本身依然能独立传达含义。🖋️

---

每个故事都以同样的方式开场：一间昏暗的房间，一台终端，一个不停闪烁的光标，直到
你给它一件事去做。

![一台孤零零发光的控制台终端，在黑暗的工坊里](../../comic/panel-1.jpg)
> 🧑‍💻 *"我有一个功能想法。……接下来呢？"*

就在这时导师出现了——没有光剑，只有一卷羊皮卷，因为这里的第一场战斗从来都不是
最后一场。`/specjedi-constitution` 把规则写下一次，往后就再也不用有人因为没学到
而在三个功能之后吃苦头。

![一个戴兜帽、像档案管理员的导师身影，正展开一卷发光的数据卷轴](../../comic/panel-2.jpg)
> 🧙 *"先立法典。"* 📜

接下来想法被贴到墙上，周围环绕着它还没能回答的每一个问题——到底在造什么，为了
谁。`/specjedi-specify` 把它变成一份真正的 `spec.md`；`/specjedi-clarify` 出发去
猎捕歧义，赶在它变成一个没人愿意认领的 bug 之前。

![一块贴满全息便利贴和发光问号的软木板](../../comic/panel-3.jpg)
> 🌀 *"你到底在造什么——为了谁？"*

然后蓝图出现了。`/specjedi-plan` 变成 `plan.md`，`/specjedi-tasks` 把它拆解成一份
有序、感知依赖关系的 `tasks.md`——一步不落，次序不乱，是那种 Padawan 不用反复
确认就能照着执行的计划。

![一张技术示意图在杂乱的工作台上展开](../../comic/panel-4.jpg)
> 🛠️ *"现在轮到'怎么做'。"*

工具开始嗡嗡作响。测试一个接一个地以红色失败——然后，渐渐地，它们不再失败。
`/specjedi-implement` 在适用之处以测试先行的方式执行 `tasks.md`
（[Principle VI](../../../.specify/memory/constitution.md)），因为跳过这一步的
构建不过是多了几个步骤的猜测。

![工坊墙上的状态灯从红色闪烁变为绿色](../../comic/panel-5.jpg)
> 🤖 *"测试优先，永远优先。"*

现在议事会召开了——不是为了给工作盖章祝福，只是为了检查它。一份拉取请求站在长凳
前，`ci-gate` 🤖 运行完整的验证 battery：每一种操作系统、每一项检查，没有捷径。
这里不允许任何人批准自己的工作——无论是机器还是人
（[Principle X](../../../.specify/memory/constitution.md)）。

![一间圆形议事厅，戴兜帽的长老们围坐在一座高台四周](../../comic/panel-6.jpg)
> 🏛️ *"陈述你的改动。"*

灯光转绿，闸门自行打开——没有一只手放在拉杆上，没有人点击按钮。battery 已经说
出了它该说的话。

![一扇巨大的机械装甲门在绿色信标光下缓缓开启](../../comic/panel-7.jpg)
> ✅ *"battery 已经表态。"*

然后它就离开了——奔赴超空间，交付完成。

![一艘造型原创的优雅飞船在星海中疾驰远去](../../comic/panel-8.jpg)
> 🚀 *"已交付。"*
> 🌌 *"愿原力与你同在。"*

这一切都不是童话——这正是本项目自己近期这些拉取请求（例如
[#82](https://github.com/jonyfs/spec-jedi/pull/82)、
[#84](https://github.com/jonyfs/spec-jedi/pull/84)、
[#87](https://github.com/jonyfs/spec-jedi/pull/87)，仅举几例）背后真实、反复上演
的流程——每一次都实打实地从头到尾走完，每次都是如此。

### 同样的故事，以图表呈现

```mermaid
sequenceDiagram
    participant Dev as 🧑‍💻 Contributor
    participant Repo as 📜 Repo (main)
    participant PR as 🔀 Pull Request
    participant CI as 🤖 ci-gate
    Dev->>Repo: /specjedi-constitution, /specjedi-specify, /specjedi-plan, /specjedi-tasks
    Dev->>Dev: /specjedi-implement (test-first)
    Dev->>PR: open PR on a feature branch
    PR->>CI: trigger validation battery (Linux/macOS/Windows)
    CI-->>PR: 🔴 red? fix and push again
    CI-->>PR: 🟢 green? proceed
    PR->>Repo: auto-merge (no self-approval, checks-only gate)
    Repo-->>Dev: 🚀 shipped — "This is the way."
```

## 前置条件

这里没有什么特别的东西。Spec Jedi 在 **Linux、macOS 和 Windows** 上同等构建并测试
（Constitution [Principle XIII](../../../.specify/memory/constitution.md)）——
`scripts/` 下的每个脚本都同时提供 POSIX shell（`.sh`）和原生 PowerShell（`.ps1`）
两个版本，CI 在每个 PR 上都会在这三种操作系统上运行完整的验证 battery。

真正需要的东西：

- `git`
- 一个受支持的编码智能体（见下方[受支持的宿主环境](#受支持的宿主环境)）
- [GitHub CLI（`gh`）](https://cli.github.com/)——仅当你计划把改动以拉取请求
  发回时才需要
- 一个用于本地运行辅助脚本的 shell，如果你想的话（编码智能体本身不需要这个）：
  bash/zsh（Linux 和 macOS 默认自带），或者
  [PowerShell 7+](https://aka.ms/powershell)（`pwsh`），它可以在任何地方运行

## 安装

一条命令。无需 `git clone`。`scripts/bootstrap-install.sh`/`.ps1`（如果想看完整
来龙去脉，见 specs/024-bootstrap-installer）会为你拉取一个已发布的 GitHub
Release，并直接在你的目标目录中运行其内置的安装程序：

```bash
curl -fsSL https://raw.githubusercontent.com/jonyfs/spec-jedi/main/scripts/bootstrap-install.sh \
  | bash -s -- /path/to/your-project --harness cursor
```

```powershell
&([scriptblock]::Create((iwr -useb https://raw.githubusercontent.com/jonyfs/spec-jedi/main/scripts/bootstrap-install.ps1).Content)) -TargetDir C:\path\to\your-project -Harness cursor
```

`--harness` 是可选的。如果省略，安装程序会尝试判断你正在使用哪个编码智能体——
`claude-code`、`codex-cli` 或 `trae`——方法是检查是否已存在项目目录、`PATH` 中
是否有对应可执行文件，或是否已存在全局配置文件夹，只有在检测到多个可能匹配时才
会询问。其余 17 个宿主环境目前还没有可靠的检测信号，因此需要你自己传入
`--harness`——完整列表就在下方的[受支持的宿主环境](#受支持的宿主环境)。运行
`./scripts/bootstrap-install.sh --help`（或
`.\scripts\bootstrap-install.ps1 -Help`）随时查看完整选项列表，包括 `--auto`。

对于 `claude-code`、`codex-cli` 和 `trae`，安装程序还会创建或更新该宿主环境
自身的项目记忆文件（`CLAUDE.md`、`AGENTS.md`，或
`.trae/rules/project_rules.md`），插入一小段用标记分隔的内容，列出已安装的
技能——这样宿主环境自身的上下文就已经知道这些技能的存在，而不只是技能目录本身
知道。如果该文件已经存在且带有你自己的内容，你的内容不会被触碰；这段内容只会被
追加进去，而且以后重新安装时也只会刷新这一段。

### 受支持的宿主环境

章程（[Principle III](../../../.specify/memory/constitution.md)）承诺该项目
支持市场上使用率最高的二十种编码智能体——截至本次发布，全部二十个都是真实、
经过测试、CI 验证过的，绝非空想。其中四个原生从磁盘读取技能（Claude Code、
Codex CLI、Trae、Antigravity——后三者只共享两个物理目标目录，
`.agents/skills/` 和 `.trae/skills/`，OpenCode 和 Warp 无需额外代码即可通过
这些相同路径得到满足）。其余十四个完全没有原生的技能概念——只有一个项目根目录
规则文件、一个小型规则目录，或者（对 Sourcegraph Cody 而言）一个自定义命令
JSON 文件——因此安装程序会构建一个**桥接**：真实的 `specjedi-*` 包仍然落在
标准位置 `.claude/skills/`，再由一个小的适配器（一个文件，或对目录式宿主环境
而言每个技能一个文件）用该宿主环境自己真正文档化的约定指向它。

参见 [`specs/023-full-harness-coverage/research.md`](../../../specs/023-full-harness-coverage/research.md)
了解每个宿主环境确切机制背后的引用出处——这里没有任何东西是靠猜的。

| 宿主环境 | 状态 |
|---|---|
| Claude Code | ✅ 已支持——上方的[安装](#安装)命令，省略 `--harness`（自动检测）或显式传入 `--harness claude-code` |
| Cursor | ✅ 已支持——`./scripts/install.sh --harness cursor`（桥接文件位于 `.cursor/rules/`） |
| GitHub Copilot（Chat/Workspace） | ✅ 已支持——`./scripts/install.sh --harness copilot`（桥接文件位于 `.github/copilot-instructions.md`） |
| Codex CLI（OpenAI） | ✅ 已支持——`./scripts/install.sh --harness codex-cli`（安装到 `.agents/skills/`） |
| Gemini CLI | ✅ 已支持——`./scripts/install.sh --harness gemini-cli`（桥接文件位于 `GEMINI.md`；Google 正在逐步淘汰 Gemini CLI，转向 Antigravity——见 [`references/harness-capability-notes.md`](../../../references/harness-capability-notes.md)） |
| Antigravity（Google） | ✅ 已支持——`./scripts/install.sh --harness antigravity`（安装到 `.agents/skills/`，与 Codex CLI 采用相同约定） |
| Windsurf（Codeium） | ✅ 已支持——`./scripts/install.sh --harness windsurf`（桥接文件位于 `.windsurf/rules/`） |
| Cline | ✅ 已支持——`./scripts/install.sh --harness cline`（桥接文件位于 `.clinerules/`） |
| Continue | ✅ 已支持——`./scripts/install.sh --harness continue`（桥接文件位于 `.continue/rules/`） |
| Aider | ✅ 已支持——`./scripts/install.sh --harness aider`（桥接文件位于 `CONVENTIONS.md`） |
| Amazon Q Developer | ✅ 已支持——`./scripts/install.sh --harness amazon-q`（桥接文件位于 `.amazonq/rules/`） |
| JetBrains AI Assistant | ✅ 已支持——`./scripts/install.sh --harness jetbrains-ai`（桥接文件位于 `.aiassistant/rules/`） |
| Zed | ✅ 已支持——`./scripts/install.sh --harness zed`（桥接文件位于 `.rules`） |
| OpenCode | ✅ 已支持——通过 `claude-code` 或 `codex-cli` 安装均可满足（OpenCode 会原生扫描 `.claude/skills/` 和 `.agents/skills/`），无需单独的标志 |
| Warp（Agent Mode） | ✅ 已支持——通过 `claude-code` 或 `codex-cli` 安装均可满足（Warp 的 Skills 系统会原生扫描 `.claude/skills/` 和 `.agents/skills/`），无需单独的标志 |
| Replit Agent | ✅ 已支持——`./scripts/install.sh --harness replit`（桥接文件位于 `replit.md`） |
| Devin（Cognition） | ✅ 已支持——`./scripts/install.sh --harness devin`（桥接文件位于 `.devin.md`，按 Devin Playbook 格式组织） |
| Tabnine | ✅ 已支持——`./scripts/install.sh --harness tabnine`（桥接文件位于 `.tabnine/guidelines/`） |
| Sourcegraph Cody | ✅ 已支持——`./scripts/install.sh --harness cody`（`.vscode/cody.json` 自定义命令，需显式调用为 `/specjedi-<name>`；与上面其他宿主环境不同，Cody 没有确认可用的常驻规则文件，因此这是手动调用，而非自动加载的上下文——详见研究文档） |
| Trae | ✅ 已支持——`./scripts/install.sh --harness trae`（安装到 `.trae/skills/`） |

二十种宿主环境逐一列出，全部 ✅ 已支持——这正是 Principle III 自身设定的标准。
对本项目尚未实际构建和测试过的机制不作任何能力方面的断言；Principle XX 不允许
在这里靠猜。

想了解更多？[`references/harness-capability-notes.md`](../../../references/harness-capability-notes.md)
收录了每个宿主环境最初的桌面调研笔记，而
[`specs/023-full-harness-coverage/research.md`](../../../specs/023-full-harness-coverage/research.md)
收录了这整张表格所依据的真实安装机制决策与引用出处。

## 诚实评估

真实的优势，真实的当前局限——不是一份营销页面。二十个目标宿主环境中的二十个都
拥有经过 CI 测试的真实安装路径，图表在展示前都经过渲染验证，已经交付了四个真实
版本（`v0.1.0`、`v0.1.1`、`v0.2.0`、`v0.3.0`），章程是一份活的、带版本管理的
文档，当前版本 v1.29.0，带有完整记录的修订历史。另一半坦率地说：大多数桥接式
宿主环境的安装路径都建立在桌面调研之上，而不是在真实的第三方产品中亲手验证过
（见下文）；而且本项目自身的本地化文档往往落后于英文原文——`scripts/validate.sh`
目前将全部 10 份已翻译的 `README.md` 和 `CONTRIBUTING.md` 副本标记为与最新英文
改动不同步，这是一个真实、反复出现、本项目尚未从结构上解决的缺口。完整、不加
过滤的全貌，见
[`references/honest-assessment.md`](../../../references/honest-assessment.md)。

二十种宿主环境逐一列出，全部经过 CI 验证——但除 Claude Code 之外的 19 个宿主
环境中，有 18 个是通过桌面调研确认的（每个宿主环境引用一个来源），而不是通过
实际安装到真实产品中、观察某个技能被加载来确认的；只有 Sourcegraph Cody 的状态
在更深入的后续调研之后发生了变化，那次调研没有找到已确认的常驻规则文件。各宿主
环境的引用出处及完整研究历史，见
[`references/harness-capability-notes.md`](../../../references/harness-capability-notes.md)。

好奇 Spec Jedi 与 spec-kit 及其对标的另外十款 SDD 工具相比如何？
[`references/competitive-comparison.md`](../../../references/competitive-comparison.md)
有确凿的依据。

## 贡献

[`CONTRIBUTING.md`](./CONTRIBUTING.md) 收录了完整的流程——新技能的竞品研究要求、
技能编写标准检查清单，以及打开 PR 前要运行的验证步骤。

每一次改动都通过拉取请求交付，由本项目自己的 CI battery 验证，只有在每一项检查
都变绿之后才会自动合并
（见 [Principle IX 和 X](../../../.specify/memory/constitution.md)）。这套
battery 在每个 PR 上都会在 Linux、macOS 和 Windows 上运行（Principle XIII）——
如果你在 `scripts/` 下新增或修改了脚本，`.sh` 和 `.ps1` 两个版本都必须存在，
并且都要在三种系统上通过，没有例外。Issue 和 PR 模板
（`.github/ISSUE_TEMPLATE/`、`.github/PULL_REQUEST_TEMPLATE.md`）会引导你在
申请审查前确认已完成上述研究和验证步骤。

## 许可证

[MIT](../../../LICENSE)——由本项目自己的章程要求使用（Distribution & Ecosystem
Standards），不只是一个没人多想的默认选择。用大白话说，MIT 意味着你可以：

- **使用**本项目，无论商业与否，不受限制。
- 随意**修改**它。
- **再分发**它，包括作为你所出售之物的一部分。

真正的条件只有两条：在你的副本中保留原始版权声明和许可证文本，并且不要期待任何
担保——软件是"按现状"提供的，出问题概不负责。这就是全部约定；如果你想要逐字
逐句的确切法律文本，见 [`LICENSE`](../../../LICENSE)。

---

🌌 *愿原力与你同在。*
