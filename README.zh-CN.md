# Festival

**让 Claude Code、Codex、Cursor 和其他 AI 编程代理在跨天、跨项目的工作中不丢上下文。**

Festival 是一个 local-first 的工作流层，用文件系统保存项目记忆、结构化计划、决策记录和下一步行动。你的计划、进度和上下文都在仓库旁边的 Markdown 文件里，不绑定某一个 AI 工具或云服务。

如果你正在用 AI 编程代理做长期功能、重构、发布、研究或多仓库工作，Festival 的目标很简单：下一次会话不需要从零开始解释。

> 如果你想要面向长期 AI 编程工作的本地优先工作流，可以先 Star 这个仓库，方便之后回来试用。

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

Festival 的核心循环是：

```bash
fest next                 # 获取下一步行动和上下文
# 用 Claude Code、Codex、Cursor 或其他代理完成工作
fest task completed       # 在文件系统中记录进度
fest commit -m "message"  # 提交代码，并保留计划追踪信息
```

明天回来、换一个 AI 工具、或者切到同一个 campaign 里的另一个仓库时，继续运行：

```bash
fest next
```

Festival 会根据文件中的计划和状态告诉代理下一步该做什么。

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

[Functional Source License 1.1 (FSL-1.1-ALv2)](LICENSE)

Built by [Obedience Corp](https://obediencecorp.com). AI that does what you want, the way you want it done.
