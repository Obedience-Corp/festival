---
title: "AI 编程代理工作流"
weight: 63
---

# AI 编程代理工作流

这个示例展示如何用 Festival 协调 Claude Code、Codex、Cursor 或其他 AI 编程代理完成一个跨会话功能。

## 场景

你要给一个 API 服务增加 rate limit。这个工作需要：

- 阅读现有 middleware
- 设计配置格式
- 实现限制逻辑
- 增加测试
- 更新文档
- 做一次人工审查

不用 Festival 时，这些计划通常散落在聊天记录里。下次会话开始时，代理不知道哪些已经完成，也不知道下一步应该做什么。

## 1. 创建 campaign 并添加项目

```bash
camp init api-work
cd api-work
camp project add https://github.com/you/api-service
```

## 2. 创建 festival

```bash
fest create festival --name "api-rate-limit" --type standard
```

填完生成文件中的 `REPLACE` 标记，然后运行：

```bash
fest validate
```

## 3. 确认当前 work item

先让代理确认 campaign 当前工作：

```bash
camp workitem current
```

如果没有当前 work item，可以查看 active 工作队列：

```bash
camp workitem --json --stage active
```

## 4. 让代理获取 festival 下一步

在 Claude Code、Codex、Cursor 终端或任何 agent shell 中运行：

```bash
fest next
```

代理会拿到当前任务、所属 phase、festival 目标和相关上下文。你不需要把整套计划重新粘贴进聊天框。

## 5. 完成任务并记录状态

代理完成当前任务后运行：

```bash
fest task completed
fest commit -m "add rate limit middleware"
```

`fest commit` 会把提交和当前 festival/task 关联起来，方便之后审查。

## 6. 换工具或第二天继续

下一次会话，不管你使用 Claude Code、Codex 还是 Cursor，都先确认 campaign 当前工作：

```bash
camp workitem current
```

如果当前工作是同一个 active festival，再运行：

```bash
fest next
```

Festival 会从文件系统状态中恢复上下文，返回下一步可执行任务。

## 推荐给代理的提示词

```text
Use Festival for this project. Start by running `camp workitem current`.
If the current work item is an active festival, run `fest next`.
Follow the task instructions, run the required validation commands,
mark completed festival work with `fest task completed`, and commit with `fest commit`.
If this is not festival task execution, read the resolved work item and commit with `camp workitem commit`.
If context is missing, inspect the campaign work item or festival files before making assumptions.
```

## 关键原则

- 不把计划只留在聊天记录里
- 不要求代理一次读完整个项目
- 每个任务都要有完成标准
- 每次会话都能用 `fest next` 恢复
- 所有重要上下文都应该进入文件，方便人和代理共同审查
