> **注意：** 本仓库包含 Anthropic 为 Claude 实现的技能集合。有关 Agent Skills 标准的信息，请访问 [agentskills.io](http://agentskills.io)。

# Skills（技能）

技能是包含指令、脚本和资源的文件夹，Claude 可以动态加载这些内容以提升在特定任务上的表现。技能教会 Claude 如何以可重复的方式完成特定任务，无论是使用您公司的品牌指南创建文档、使用您组织的特定工作流程分析数据，还是自动化个人任务。

更多信息，请查看：
- [什么是技能？](https://support.claude.com/en/articles/12512176-what-are-skills)
- [在 Claude 中使用技能](https://support.claude.com/en/articles/12512180-using-skills-in-claude)
- [如何创建自定义技能](https://support.claude.com/en/articles/12512198-creating-custom-skills)
- [使用 Agent Skills 为现实世界配备智能体](https://anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)

# 关于本仓库

本仓库包含的技能展示了 Claude 技能系统的可能性。这些技能涵盖从创意应用（艺术、音乐、设计）到技术任务（测试 Web 应用、MCP 服务器生成）再到企业工作流程（通信、品牌等）的各个方面。

每个技能都自包含在各自的文件夹中，包含一个 `SKILL.md` 文件，其中包含 Claude 使用的指令和元数据。浏览这些技能可以获得创建自己技能的灵感，或了解不同的模式和方法。

本仓库中的许多技能都是开源的（Apache 2.0）。我们还包含了在 [`skills/docx`](./skills/docx)、[`skills/pdf`](./skills/pdf)、[`skills/pptx`](./skills/pptx) 和 [`skills/xlsx`](./skills/xlsx) 子文件夹中为 [Claude 的文档功能](https://www.anthropic.com/news/create-files) 提供支持的文档创建和编辑技能。这些是源代码可用的，不是开源的，但我们希望与开发者分享这些作为参考，展示在生产 AI 应用中积极使用的更复杂技能。

## 免责声明

**这些技能仅用于演示和教育目的。** 虽然其中一些功能可能在 Claude 中可用，但您从 Claude 收到的实现和行为可能与这些技能中显示的内容不同。这些技能旨在说明模式和可能性。在将技能用于关键任务之前，请务必在您自己的环境中彻底测试。

# 技能集合

- [./skills](./skills): 创意与设计、开发与技术、企业与通信以及文档技能的示例
- [./spec](./spec): Agent Skills 规范
- [./template](./template): 技能模板

## 可用技能列表

### 文档处理技能（Document Skills）
- **docx** - 全面的文档创建、编辑和分析，支持跟踪更改、评论、格式保留和文本提取
- **pdf** - PDF 文件处理，包括表单填写、字段提取、图像转换等功能
- **pptx** - PowerPoint 演示文稿的创建、编辑和操作
- **xlsx** - Excel 电子表格处理，包括数据操作和重新计算

### 创意与设计技能（Creative & Design Skills）
- **algorithmic-art** - 使用 p5.js 创建算法艺术，支持种子随机数和交互式参数探索
- **brand-guidelines** - 品牌指南和设计规范
- **canvas-design** - Canvas 设计工具，包含丰富的字体资源
- **frontend-design** - 前端设计和开发
- **theme-factory** - 主题工厂，创建各种视觉主题

### 开发与技术技能（Development & Technical Skills）
- **mcp-builder** - MCP（Model Context Protocol）服务器构建工具
- **skill-creator** - 创建有效技能的指南和工具
- **webapp-testing** - Web 应用测试和自动化
- **web-artifacts-builder** - Web 工件构建工具

### 企业与通信技能（Enterprise & Communication Skills）
- **internal-comms** - 内部通信和文档编写
- **doc-coauthoring** - 文档协作编写

### 其他技能
- **slack-gif-creator** - Slack GIF 创建工具

# 在 Claude Code、Claude.ai 和 API 中使用

## Claude Code

您可以通过在 Claude Code 中运行以下命令，将此仓库注册为 Claude Code 插件市场：

```
/plugin marketplace add anthropics/skills
```

然后，要安装特定的技能集合：

1. 选择 `Browse and install plugins`（浏览并安装插件）
2. 选择 `anthropic-agent-skills`
3. 选择 `document-skills` 或 `example-skills`
4. 选择 `Install now`（立即安装）

或者，直接通过以下方式安装任一插件：

```
/plugin install document-skills@anthropic-agent-skills
/plugin install example-skills@anthropic-agent-skills
```

安装插件后，只需提及即可使用技能。例如，如果您从市场安装了 `document-skills` 插件，可以要求 Claude Code 执行类似操作："使用 PDF 技能从 `path/to/some-file.pdf` 提取表单字段"

## Claude.ai

这些示例技能在 Claude.ai 的付费计划中都已可用。

要使用本仓库中的任何技能或上传自定义技能，请按照 [在 Claude 中使用技能](https://support.claude.com/en/articles/12512180-using-skills-in-claude#h_a4222fa77b) 中的说明操作。

## Claude API

您可以通过 Claude API 使用 Anthropic 的预构建技能，并上传自定义技能。更多信息请参阅 [Skills API 快速入门](https://docs.claude.com/en/api/skills-guide#creating-a-skill)。

# 创建基础技能

技能创建很简单——只需一个包含 `SKILL.md` 文件的文件夹，该文件包含 YAML 前置元数据和指令。您可以使用本仓库中的 **template-skill** 作为起点：

```markdown
---
name: my-skill-name
description: 清晰描述此技能的功能以及何时使用它
---

# 我的技能名称

[在此添加 Claude 在此技能激活时将遵循的指令]

## 示例
- 示例用法 1
- 示例用法 2

## 指南
- 指南 1
- 指南 2
```

前置元数据只需要两个字段：
- `name` - 您技能的唯一标识符（小写，使用连字符代替空格）
- `description` - 完整描述技能的功能以及何时使用它

下面的 Markdown 内容包含 Claude 将遵循的指令、示例和指南。更多详细信息，请参阅 [如何创建自定义技能](https://support.claude.com/en/articles/12512198-creating-custom-skills)。

# 合作伙伴技能

技能是教 Claude 如何更好地使用特定软件的好方法。当我们看到合作伙伴的优秀示例技能时，我们可能会在此处重点介绍一些：

- **Notion** - [Notion Skills for Claude](https://www.notion.so/notiondevs/Notion-Skills-for-Claude-28da4445d27180c7af1df7d8615723d0)

# 技能结构说明

每个技能文件夹通常包含以下内容：

```
skill-name/
├── SKILL.md          # 必需：技能的主要指令文件
├── LICENSE.txt       # 许可证信息（如适用）
├── scripts/          # 可选：可执行脚本（Python/Bash 等）
├── references/       # 可选：参考文档
├── templates/        # 可选：模板文件
└── assets/           # 可选：资源文件（字体、图标等）
```

## SKILL.md 文件结构

每个 `SKILL.md` 文件包含：

1. **YAML 前置元数据**（必需）
   - `name`: 技能的唯一标识符
   - `description`: 技能的详细描述（非常重要，Claude 使用此描述来决定何时使用技能）
   - `license`: 许可证信息（可选）

2. **Markdown 指令内容**（必需）
   - 技能的具体指令和工作流程
   - 使用示例
   - 技术要求和最佳实践

## 技能分类

### 文档技能（Document Skills）
这些技能为 Claude 提供了处理各种文档格式的能力：
- **docx**: Word 文档的创建、编辑和分析
- **pdf**: PDF 文件的处理和操作
- **pptx**: PowerPoint 演示文稿的处理
- **xlsx**: Excel 电子表格的处理

### 示例技能（Example Skills）
这些技能展示了技能系统的各种可能性：
- **algorithmic-art**: 算法艺术生成
- **brand-guidelines**: 品牌指南应用
- **canvas-design**: Canvas 设计工具
- **frontend-design**: 前端设计
- **internal-comms**: 内部通信
- **mcp-builder**: MCP 服务器构建
- **skill-creator**: 技能创建指南
- **slack-gif-creator**: Slack GIF 创建
- **theme-factory**: 主题生成
- **webapp-testing**: Web 应用测试
- **web-artifacts-builder**: Web 工件构建

# 贡献和使用

本仓库中的技能可以作为：
- **学习资源**：了解如何创建有效的技能
- **参考实现**：查看复杂技能的实现方式
- **起点模板**：基于现有技能创建自己的技能

# 许可证

- 大多数技能使用 **Apache 2.0** 许可证（开源）
- 文档技能（docx、pdf、pptx、xlsx）是**源代码可用**的，不是开源的
- 每个技能文件夹中的 `LICENSE.txt` 文件包含完整的许可证条款

# 相关资源

- [Agent Skills 规范](./spec/agent-skills-spec.md)
- [技能模板](./template/SKILL.md)
- [第三方声明](./THIRD_PARTY_NOTICES.md)

# 获取帮助

如果您在创建或使用技能时遇到问题：
1. 查看 [技能创建指南](./skills/skill-creator/SKILL.md)
2. 参考现有技能的实现
3. 查看 [Agent Skills 规范](./spec/agent-skills-spec.md)

---

**最后更新**: 基于原始 README.md 创建的中文版本

