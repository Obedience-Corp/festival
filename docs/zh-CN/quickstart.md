---
title: "中文快速开始"
weight: 61
---

# 中文快速开始

Festival 是面向长期 AI 编程工作的 local-first 工作流层。它让 Claude Code、Codex、Cursor 和其他代理可以通过文件系统共享工作队列、计划、上下文、决策和下一步行动。

## 1. 安装 Claude Code 插件

如果你使用 Claude Code，推荐先安装插件：

```bash
claude plugin add --source git-subdir --url Obedience-Corp/festival --path claude-plugin
```

然后在 Claude Code 中运行：

```text
/fest-create
/fest-next
```

插件会在需要时自动安装 `fest` 和 `camp`。

## 2. 或者安装 CLI

```bash
npm install -g @obedience-corp/festival
```

macOS:

```bash
brew install --cask Obedience-Corp/tap/festival
```

Arch Linux:

```bash
yay -S festival-bin
```

Debian / Ubuntu 可以从 [latest release](https://github.com/Obedience-Corp/festival/releases/latest) 下载 `.deb` 包。

## 3. 创建 campaign

campaign 是一个长期工作区，可以包含多个项目、文档、研究和计划。

```bash
camp init my-project
cd my-project
```

## 4. 添加项目

```bash
camp project add https://github.com/you/your-repo
```

项目会作为 git submodule 放到 `projects/` 下。

## 5. 创建第一个 festival

festival 是一个结构化计划，通常包含 phase、sequence 和 task。

```bash
fest create festival --name "my-first-feature" --type standard
```

生成文件后，填完 `REPLACE` 标记，再运行：

```bash
fest validate
```

## 6. 让代理开始工作

先确认 campaign 里的当前工作：

```bash
camp workitem current
```

如果还没有当前 work item，可以查看 active 工作队列：

```bash
camp workitem --json --stage active
```

当当前 work item 是 active festival 时，运行：

```bash
fest next
```

`fest next` 会返回下一步任务和相关上下文。代理完成任务后运行：

```bash
fest task completed
fest commit -m "implement feature"
```

下一次会话先用 `camp workitem current` 确认工作范围；如果仍在同一个 active festival 中，继续运行 `fest next`，就可以从上次停止的位置恢复。

## 继续阅读

- [为什么需要 Festival]({{< ref "/zh-CN/why-festival" >}})
- [AI 编程代理工作流]({{< ref "/zh-CN/agent-workflow" >}})
- [完整英文 Quick Start]({{< ref "/getting-started/quickstart" >}})
