# Festival

**你的文件。任何代理。**

**让 Claude Code、Codex、Cursor 和其他 AI 编程代理在跨天、跨项目的工作中不丢上下文。**

Festival 是一个 local-first 的工作流层，用文件系统保存项目记忆、工作队列、结构化计划、决策记录和下一步行动。你的计划、进度和上下文都在仓库旁边的 Markdown 文件里，不绑定某一个 AI 工具或云服务。

Festival 有三个核心组件：

- `camp` 管理 campaign：项目、intent、设计文档、探索记录、work item、链接关系和当前工作。
- `fest` 管理 festival：当工作复杂到需要 phase、sequence、task、质量门和跨会话追踪时，用它来执行结构化计划。
- `festival` 负责安装和更新 `camp` 和 `fest`：`festival install` 安装、`festival update` 保持三者同步、`festival browse` 查看可用内容、`festival doctor` 检查安装状态。

如果你正在用 AI 编程代理做长期功能、重构、发布、研究或多仓库工作，Festival 的目标很简单：下一次会话不需要从零开始解释。

> 如果你想要面向长期 AI 编程工作的本地优先工作流，可以先 Star 这个仓库，方便之后回来试用。

## 常见问题

**这是一个编程代理吗？**

不是。继续用你已经在用的 Claude Code、Codex、Grok 或其他工具。Festival 是这些代理读写的工作系统。

**记忆保存在哪里？**

在你自己的 campaign 里：phase、sequence、task、intent 和 git 历史，都是你目录下的普通文件。你可以复制它、diff 它，也可以带着它离开。

**一次会话结束之后呢？**

下一个可执行任务仍然在磁盘上。`fest next` 就是恢复方式，换一个代理工具也一样。

**怎么知道工作真的完成了？**

每个 task 都有完成标准，`fest validate` 按方法论检查计划结构，质量门在 sequence 结束时运行，`fest commit` 把改动关联回它对应的 task。这条链路就是工作的证据。

**需要注册账号或者云服务吗？**

不需要。`camp`、`fest` 和 `festival` 是本地二进制文件。它们写下的一切都是你工作区里的文件，不会经过 Obedience Corp 的服务。模型和代理仍然由你自己选择。

<p align="center">
  <img src="docs/images/demos/proof-loop.gif" alt="One sentence of intent scaffolds a festival, an agent runs the next task, the session is interrupted, fest next resumes it, then fest validate and fest commit close it out" width="700">
</p>
<p align="center"><em>一句话说明意图，festival 随即生成结构。代理执行下一个 task，会话中断后 <code>fest next</code> 接着往下走，最后 <code>fest validate</code> 和 <code>fest commit</code> 收尾。</em></p>

## 先从 Claude Code 开始

安装 Festival 插件：

```bash
claude plugin add --source git-subdir --url Obedience-Corp/festival --path claude-plugin
```

然后在 Claude Code 里运行：

```text
/fest-create
/fest-next
```

插件会在需要时自动安装 `fest` 和 `camp`，并提供 slash commands、方法论 skills、规划代理和执行代理。

## 安装 CLI

如果你想在 Codex、Cursor、Aider、OpenCode 或普通终端中直接使用 Festival，可以安装 CLI：

```bash
npm install -g @obedience-corp/festival
```

macOS 也可以用 Homebrew：

```bash
brew install --cask Obedience-Corp/tap/festival
```

Arch Linux：

```bash
yay -S festival-bin
```

Debian / Ubuntu 可以从 [latest release](https://github.com/Obedience-Corp/festival/releases/latest) 下载 `.deb` 包。

Windows 稳定包暂时暂停维护；目前建议使用 WSL2 和 Linux 安装方式。

## 60 秒理解工作流

先用 `camp workitem` 找到或确认当前工作：

```bash
camp workitem                         # 查看 campaign 里的工作队列
camp workitem --json --stage active   # 给代理或脚本使用的机器可读输出
camp workitem current                 # 查看当前 work item
camp workitem current my-feature      # 设置当前 work item
```

用 intent 快速捕获想法；只有复杂度值得时才提升成 festival：

```bash
camp intent add "Add rate limiting to the API"
camp intent list --status ready
camp intent promote rate-limiting
```

进入 active festival 后，再用 `fest next` 获取下一步任务：

```bash
fest next                 # 获取下一步行动和上下文
# 用 Claude Code、Codex、Cursor 或其他代理完成工作
fest task completed       # 在文件系统中记录进度
fest commit -m "message"  # 提交代码，并保留计划追踪信息
```

明天回来、换一个 AI 工具、或者切到同一个 campaign 里的另一个仓库时，先用 `camp workitem` 找到当前工作；如果当前工作是 active festival，再继续运行：

```bash
fest next
```

Festival 会根据文件中的计划和状态告诉代理下一步该做什么。

不是每个 work item 都需要 festival。范围清楚的 intent 或设计文档可能足够让代理在一次会话中完成。Festival 适合需要长期计划、质量门、可追踪执行记录的工作。

## Festival 解决什么问题

AI 编程工具很快，但会话本身通常是短暂的。每次重开会话，你都要重新解释：

- 项目背景是什么
- 上一次做到哪里
- 哪些决策已经做过
- 下一步应该先做什么
- 完成后如何验证

Festival 把这些东西放进一个可审查、可提交、可恢复的工作结构里：

- **Context**：一个 campaign 工作区，保存项目、文档、研究和计划
- **Direction**：可由 AI 代理执行、暂停和恢复的结构化计划
- **Verification**：每一步都有可检查的完成标准和可追踪输出

## 示例和文档

- [中文快速开始](docs/zh-CN/quickstart.md)
- [为什么需要 Festival](docs/zh-CN/why-festival.md)
- [AI 编程代理工作流示例](docs/zh-CN/agent-workflow.md)
- [Claude Code workflow example](examples/claude-code-workflow/)
- [Agentic feature build template](templates/agentic-feature-build/)
- [完整英文文档](https://docs.fest.build)

## License

[Apache License 2.0](LICENSE)

Built by [Obedience Corp](https://obediencecorp.com). AI that does what you want, the way you want it done.
