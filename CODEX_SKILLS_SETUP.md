# Codex Skills 快速加载指南

## 概述

根据 [OpenAI Codex Skills 文档](openai-skills-guide/overview.md)，Codex 会从以下位置按优先级加载 skills：

1. **`$CWD/.codex/skills`** - 当前工作目录（最高优先级）⭐
2. `$CWD/../.codex/skills` - 上一级目录
3. `$REPO_ROOT/.codex/skills` - Git 仓库根目录
4. `~/.codex/skills` - 用户级别
5. `/etc/codex/skills` - 系统级别
6. SYSTEM - Codex 内置的 skills

## 快速设置

### 方法 1：指定要加载的 skills（推荐）

直接指定要加载的 skill 路径：

```bash
# 加载单个 skill
./setup-codex-skills.sh myskills/research-paper-writer

# 加载多个 skills
./setup-codex-skills.sh myskills/research-paper-writer anthropics-skills-guide/skills/doc-coauthoring
```

### 方法 2：查看可用 skills 后选择

```bash
# 1. 列出所有可用的 skills
./setup-codex-skills.sh --list

# 2. 选择要加载的 skills
./setup-codex-skills.sh <skill路径1> <skill路径2> ...
```

### 方法 3：交互式选择

```bash
./setup-codex-skills.sh --interactive
```

脚本会列出所有可用的 skills，你可以输入数字选择要加载的 skills。

### 方法 4：使用配置文件

1. 创建配置文件 `.codex-skills-config`：

```bash
# .codex-skills-config
# 每行一个 skill 路径，支持 # 注释

# 我的自定义 skills
myskills/research-paper-writer

# Anthropic skills
anthropics-skills-guide/skills/doc-coauthoring
anthropics-skills-guide/skills/pdf
```

2. 从配置文件加载：

```bash
./setup-codex-skills.sh --config .codex-skills-config
```

### 方法 5：加载所有 skills（不推荐）

如果你确实想加载所有找到的 skills：

```bash
./setup-codex-skills.sh --all
```

## 管理 Skills

### 查看已加载的 skills

```bash
ls -la .codex/skills/
```

### 移除某个 skill

```bash
./setup-codex-skills.sh --remove research-paper-writer
```

### 清理所有 skills

```bash
rm -rf .codex/skills
```

## 使用 Skills

设置完成后，重启 Codex，然后：

### 1. 查看可用 skills

在 Codex 中使用：
```
/skills
```

或者输入 `$` 然后按 Tab 键查看可用的 skills。

### 2. 显式调用 skill

在提示中使用 `$skill-name`：
```
$research-paper-writer

帮我写一篇关于机器学习的论文
```

### 3. 隐式调用

Codex 会根据你的任务描述自动选择合适的 skill。确保 skill 的 `description` 字段清晰描述了何时使用该 skill。

## 脚本选项

```bash
./setup-codex-skills.sh [选项] [skill路径...]

选项:
  -h, --help              显示帮助信息
  -l, --list              列出所有可用的 skills
  -c, --config FILE       从配置文件加载 skill 列表
  -i, --interactive       交互式选择要加载的 skills
  -r, --remove SKILL      移除指定的 skill
  -a, --all               加载所有找到的 skills
```

## 示例

### 示例 1：加载常用的 skills

```bash
# 只加载研究论文写作 skill
./setup-codex-skills.sh myskills/research-paper-writer
```

### 示例 2：从多个位置加载

```bash
./setup-codex-skills.sh \
  myskills/research-paper-writer \
  anthropics-skills-guide/skills/doc-coauthoring \
  anthropics-skills-guide/skills/pdf
```

### 示例 3：使用配置文件

```bash
# 创建配置文件
cat > .codex-skills-config << EOF
# 我常用的 skills
myskills/research-paper-writer
anthropics-skills-guide/skills/doc-coauthoring
EOF

# 加载
./setup-codex-skills.sh --config .codex-skills-config
```

## 注意事项

1. **重启 Codex**：设置或修改 skills 后，需要重启 Codex 才能生效
2. **名称冲突**：如果多个位置有同名的 skill，Codex 会使用优先级最高的（即 `.codex/skills/` 中的）
3. **符号链接**：脚本使用符号链接，所以原始文件不会被复制，修改原始文件会立即生效
4. **路径格式**：可以使用相对路径（相对于脚本所在目录）或绝对路径

## 当前目录中的 Skills 位置

- `myskills/` - 你的自定义 skills
- `anthropics-skills-guide/skills/` - Anthropic 官方 skills
- `refskills/**/SKILL.md` - 各种参考 skills（递归查找）
- `openai-skills-guide/openai-skills/skills/` - OpenAI skills

## 更多信息

- [OpenAI Codex Skills 概览](openai-skills-guide/overview.md)
- [创建自定义 Skills](openai-skills-guide/create-skills.md)
- [Agent Skills 规范](anthropics-skills-guide/spec/agent-skills-spec.md)
