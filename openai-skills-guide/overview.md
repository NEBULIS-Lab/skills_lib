# Agent Skills

Give Codex new capabilities and expertise

Use agent skills to extend Codex with task-specific capabilities. A skill packages instructions, resources, and optional scripts so Codex can follow a workflow reliably. You can share skills across teams or with the community. Skills build on the open agent skills standard.

Skills are available in both the Codex CLI and IDE extensions.

## Agent skill definition

A skill captures a capability expressed through Markdown instructions in a `SKILL.md` file. A skill folder can also include scripts, resources, and assets that Codex uses to perform a specific task.

```
my-skill/
  SKILL.md          # Required: instructions + metadata
  scripts/          # Optional: executable code
  references/       # Optional: documentation
  assets/           # Optional: templates, resources
```

Skills use progressive disclosure to manage context efficiently. At startup, Codex loads the name and description of each available skill. Codex can then activate and use a skill in two ways:

- **Explicit invocation:** You include skills directly in your prompt. To select one, run the `/skills` slash command, or start typing `$` to mention a skill. Codex web and iOS don't support explicit invocation yet, but you can still ask Codex to use any skill checked into a repo.

- **Implicit invocation:** Codex can decide to use an available skill when your task matches the skill's description.

In either method, Codex reads the full instructions of the invoked skills and any extra references checked into the skill.

## Where to save skills

Codex loads skills from these locations. A skill's location defines its scope.

When Codex loads available skills from these locations, it overwrites skills with the same name from a scope of lower precedence. The list below shows skill scopes and locations in order of precedence (high to low).

| Skill Scope | Location | Suggested Use |
|------------|----------|---------------|
| REPO | `$CWD/.codex/skills`<br>Current working directory: where you launch Codex. | If you're in a repository or code environment, teams can check in skills relevant to a working folder. For example, skills only relevant to a microservice or a module. |
| REPO | `$CWD/../.codex/skills`<br>A folder above CWD when you launch Codex inside a Git repository. | If you're in a repository with nested folders, organizations can check in skills relevant to a shared area in a parent folder. |
| REPO | `$REPO_ROOT/.codex/skills`<br>The topmost root folder when you launch Codex inside a Git repository. | If you're in a repository with nested folders, organizations can check in skills relevant to everyone using the repository. These serve as root skills that any subfolder in the repository can overwrite. |
| USER | `$CODEX_HOME/skills`<br>(macOS and Linux default: `~/.codex/skills`) | Any skills checked into the user's personal folder. Use to curate skills relevant to a user that apply to any repository the user may work in. |
| ADMIN | `/etc/codex/skills` | Any skills checked into the machine or container in a shared, system location. Use for SDK scripts, automation, and for checking in default admin skills available to each user on the machine. |
| SYSTEM | Bundled with Codex. | Useful skills relevant to a broad audience such as the `skill-creator` and `plan` skills. Available to everyone when they start Codex and can be overwritten by any layer above. |

## Create a skill

To create a new skill, use the built-in `$skill-creator` skill in Codex. Describe what you want your skill to do, and Codex will start bootstrapping your skill.

If you also install `$create-plan` (experimental) with `$skill-installer create-plan`, Codex will create a plan for your skill before it writes files.

For a step-by-step guide, see [Create custom skills](create-skills.md).

You can also create a skill manually by creating a folder with a `SKILL.md` file inside a valid skill location. A `SKILL.md` must contain a name and description to help Codex select the skill:

```yaml
---
name: skill-name
description: Description that helps Codex select the skill
metadata:
  short-description: Optional user-facing description
---

Skill instructions for the Codex agent to follow when using this skill.
```

Codex skills build on the agent skills specification. Check out the documentation to learn more.

## Install new skills

To install more than the built-in skills, you can download skills from a curated set of skills on GitHub using the `$skill-installer` skill:

```bash
$skill-installer linear
```

You can also prompt the installer to download skills from other repositories.

After installing a skill, restart Codex to pick up new skills.

## Skill examples

### Plan a new feature

`$create-plan` is an experimental skill that you can install with `$skill-installer` to have Codex research and create a plan to build a new feature or solve a complex problem:

```bash
$skill-installer create-plan
```

### Access Linear context for Codex tasks

```bash
$skill-installer linear
```

### Have Codex access Notion for more context

```bash
$skill-installer notion-spec-to-implementation
```