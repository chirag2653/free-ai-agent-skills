# AGENTS.md - Guidelines for AI Agents

> **This file provides instructions for any AI agent** (coding, marketing, design, writing, research - any domain) working with the Free AI Agent Skills repository.

---

## 🎯 Repository Purpose

This is a **public library of reusable skills** for any AI agent that supports the SKILL.md standard. Skills are self-contained capabilities that extend what AI agents can do - generating images, calling APIs, analyzing data, creating content, and more.

**Key Principles:**
1. **Universal SKILL.md Standard** - Works with any agent supporting the format (Cursor, Claude, Codex, Gemini CLI, etc.)
2. **Project-Aware** - Skills read credentials and config from the project's `.env` files
3. **Agent-Agnostic** - Works for coding, marketing, design, writing, research - any AI agent domain
4. **Security First** - No hardcoded credentials or secrets
5. **Self-Documenting** - Each skill explains what it does and how to use it
6. **Production Ready** - All skills are tested and documented

---

## 📁 Repository Structure

```
free-ai-agent-skills/
├── README.md                    # Human-facing documentation
├── AGENTS.md                    # This file - for AI agents
├── LICENSE                      # MIT license
├── .gitignore                   # Git ignore rules
├── skills/                      # All skills live here
│   └── {skill-name}/           # One folder per skill
│       ├── SKILL.md            # AI agent instructions (REQUIRED)
│       ├── scripts/            # Executable code (optional)
│       ├── references/         # Documentation loaded as needed (optional)
│       └── assets/             # Files used in output (optional)
└── catalog/
    └── skills-index.json       # Machine-readable skill catalog
```

---

## 📋 Skill Format Specification

Every skill **MUST** have a `SKILL.md` file with this format:

### SKILL.md Structure

```markdown
---
name: skill-name-in-kebab-case
description: Clear description of what the skill does AND when to use it. Include trigger phrases. This is the PRIMARY triggering mechanism.
---

# Skill Name

Brief overview and instructions for the AI agent.

## Workflow

Step-by-step instructions for the AI agent to follow.

## References

- **Detailed Guide:** See `references/guide.md` for comprehensive documentation
- **Examples:** See `references/examples.md` for conversation patterns
```

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | ✅ Yes | Kebab-case skill identifier |
| `description` | ✅ Yes | What the skill does AND when to use it. This triggers the skill. |

**Important:** Only `name` and `description` belong in frontmatter. All other metadata (version, author, tags) belongs in the `catalog/skills-index.json` file.

---

## 🔒 Security Requirements

**NEVER** commit these to the repository:
- API keys or secrets
- Credentials (passwords, tokens)
- Personal information
- `.env` or `.env.local` files

**ALWAYS:**
- Load credentials from environment variables at runtime
- Document where users should put their API keys (`.env.local` recommended)
- Use `.gitignore` to exclude sensitive files
- Validate inputs to prevent injection attacks

---

## 🎨 Coding Conventions

### File Naming

- **Skills folders**: `kebab-case-name/`
- **Documentation**: `SKILL.md`, `README.md`
- **Scripts**: descriptive names like `generate-image.sh`, `fetch-data.py`
- **Examples**: `example-*.md` or `*.example.js`

### Script Requirements

All scripts in `scripts/` folders should:
- Include a shebang line (`#!/bin/bash`, `#!/usr/bin/env python3`)
- Be executable (`chmod +x`)
- Handle errors gracefully (exit codes, try/catch)
- Print clear error messages
- Support `--help` flag

### Documentation Standards

- Use Markdown for all documentation
- Include code examples in triple-backtick blocks
- Add language tags to code blocks (```bash, ```python, etc.)
- Keep line length reasonable (~80-120 chars)
- Use headers for organization (##, ###)

---

## 🧪 Testing Guidelines

When adding or modifying skills:

1. **Test locally** - Run the skill in your own environment
2. **Test error cases** - Verify error handling works
3. **Update examples** - Ensure examples match current behavior
4. **Check compatibility** - Test on both Claude Code and Cursor if possible
5. **Validate frontmatter** - Ensure YAML is valid

---

## 🚫 What NOT to Do

**DO NOT:**
- Modify other skills without maintainer approval
- Add skills that require paid/proprietary services without clear documentation
- Include large binary files (images, videos, compiled code)
- Use deprecated or insecure dependencies
- Create skills that perform dangerous operations without safeguards
- Commit generated files (build artifacts, cache, etc.)

**ALWAYS ASK BEFORE:**
- Making breaking changes to existing skills
- Changing the repository structure
- Modifying shared documentation (README.md, AGENTS.md)
- Adding new dependencies to the repository root

---

## 📦 Adding a New Skill

Follow this process:

1. **Create skill folder** in `skills/{skill-name}/`
2. **Write SKILL.md** with proper frontmatter (`name` and `description` only)
3. **Add scripts** (if needed) in `scripts/` subfolder
4. **Add references** (if needed) in `references/` subfolder for detailed docs
5. **Update catalog** - Add entry to `catalog/skills-index.json`
6. **Test thoroughly** before submitting

### Checklist for New Skills

- [ ] `SKILL.md` with valid frontmatter (name + description only)
- [ ] SKILL.md body under 500 lines (use references/ for details)
- [ ] No hardcoded credentials or secrets
- [ ] Scripts tested and working
- [ ] Updated `catalog/skills-index.json`
- [ ] Tested locally

**Do NOT create:** README.md, CHANGELOG.md, or other auxiliary documentation files inside the skill folder. The SKILL.md is the single source of truth.

---

## 🔄 Updating Existing Skills

When updating a skill:

1. **Increment version** in SKILL.md frontmatter (follow semver)
2. **Document changes** - Update README with what changed
3. **Maintain compatibility** - Don't break existing users
4. **Add migration notes** if breaking changes are necessary

---

## 🎯 Skill Discovery

The `catalog/skills-index.json` file is the source of truth for skill discovery.

**Format:**
```json
{
  "skills": [
    {
      "name": "skill-name",
      "version": "1.0.0",
      "description": "Brief description",
      "author": "Author Name",
      "path": "skills/skill-name",
      "tags": ["tag1", "tag2"],
      "platforms": ["claude-code", "cursor"],
      "lastUpdated": "2026-01-19"
    }
  ]
}
```

**When adding a skill, update this file manually.**

---

## 🤖 For AI Agents: How to Use Skills

When a user requests functionality that matches a skill:

1. **Check if skill exists** - Look in `skills/` or `catalog/skills-index.json`
2. **Read SKILL.md** - Get instructions and metadata
3. **Use project credentials** - Skills automatically pull API keys from the project's `.env.local` or `.env` files
4. **Check requirements** - Verify dependencies are available
5. **Follow instructions** - Execute skill according to SKILL.md
6. **Work in project context** - Save outputs to appropriate project folders
7. **Handle errors** - Use error handling from skill documentation
8. **Report results** - Tell user what happened

**Key Insight:** Skills are designed to work in any project folder with that project's credentials - whether you're a coding agent, marketing agent, design agent, or any other type of AI agent.

---

## 📊 Quality Standards

All skills should meet these quality bars:

### Documentation
- ✅ Clear description of what the skill does
- ✅ When to use it (trigger conditions)
- ✅ Setup instructions
- ✅ Usage examples
- ✅ Error handling guidance

### Code Quality
- ✅ Scripts are readable and commented
- ✅ Error handling is comprehensive
- ✅ Cross-platform compatibility (where possible)
- ✅ Efficient (don't waste resources)

### Security
- ✅ No hardcoded secrets
- ✅ Input validation
- ✅ Safe defaults
- ✅ Clear permission requirements

---

## 🔧 Common Tasks

### Finding Plugin Install Paths

For Claude Code:
```bash
cat "$HOME/.claude/skills/installed_skills.json"
```

For Cursor:
```bash
cat "$HOME/.cursor/skills/installed_skills.json"
```

### Loading Environment Variables

Skills should check these locations (in order):
1. Explicit `--env-file` parameter
2. Environment variable (e.g., `$API_KEY`)
3. `.env.local` in current directory
4. `.env` in current directory
5. `~/.env.local` in home directory
6. `~/.env` in home directory

### Validating YAML Frontmatter

```bash
# Using Python
python3 -c "import yaml; yaml.safe_load(open('SKILL.md').read().split('---')[1])"

# Using yq (if installed)
yq eval - SKILL.md
```

---

## 🌍 Platform Compatibility

### Universal SKILL.md Standard

The SKILL.md format is supported by major AI agent platforms:

- **Cursor**: `~/.cursor/skills/` - Full support for SKILL.md standard
- **Claude Code**: `~/.claude/skills/` - Native SKILL.md support
- **Codex**: `~/.codex/skills/` - SKILL.md compatible
- **Gemini CLI**: Skills directory in config - Supports SKILL.md format
- **Other agents**: Any agent supporting the SKILL.md standard can use these skills

### Key Feature: Project-Aware Credentials

All skills automatically read API keys from your project's environment:
- `.env.local` (recommended for project-specific keys)
- `.env` (fallback)
- `~/.env.local` (user-level fallback)
- Environment variables

This means the same skill works across different projects with different credentials - no reconfiguration needed!

---

## 📞 Getting Help

If you're an AI agent and encounter issues:
1. Check the skill's README.md for troubleshooting
2. Check SKILL.md for specific instructions
3. Look for examples in `examples/` folder
4. Check repository issues for known problems

---

## 🎓 Best Practices Summary

1. **Read SKILL.md first** - It contains instructions for you
2. **Respect security** - Never expose credentials
3. **Follow conventions** - Keep the codebase consistent
4. **Test before commit** - Ensure changes work
5. **Document changes** - Update relevant docs
6. **Ask when uncertain** - Don't guess on critical operations

---

**This repository is designed to be agent-friendly. If you find issues with these guidelines or the skill format, please open an issue.**

---

Last updated: 2026-01-20
Version: 1.1.0
