# AGENTS.md - Guidelines for AI Coding Agents

> **This file provides instructions for AI coding agents** (Claude Code, Cursor, GitHub Copilot, etc.) working with the Free AI Agent Skills repository.

---

## 🎯 Repository Purpose

This is a **public library of reusable skills** for AI coding agents. Skills are self-contained capabilities that extend what AI agents can do - like generating images, calling APIs, analyzing code, etc.

**Key Principles:**
1. **Universal Compatibility** - Skills work across multiple AI agent platforms
2. **Security First** - No hardcoded credentials or secrets
3. **Self-Documenting** - Each skill explains what it does and how to use it
4. **Production Ready** - All skills are tested and documented

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
│       ├── README.md           # Human documentation (REQUIRED)
│       ├── scripts/            # Executable code (optional)
│       ├── examples/           # Usage examples (recommended)
│       └── tests/              # Test cases (recommended)
├── catalog/
│   └── skills-index.json       # Machine-readable skill catalog
├── docs/                        # Documentation for contributors
│   ├── creating-skills.md      # How to create new skills
│   ├── compatibility.md        # Platform compatibility info
│   └── installation.md         # Installation guides
└── examples/
    └── workflows/              # Multi-skill workflow examples
```

---

## 📋 Skill Format Specification

Every skill **MUST** have a `SKILL.md` file with this format:

### SKILL.md Structure

```markdown
---
name: skill-name-in-kebab-case
version: 1.0.0
description: Clear description of what the skill does and when to use it
author: Author Name
tags:
  - category1
  - category2
allowed-tools:
  - Read
  - Shell
  - Grep
dependencies:
  - bash
  - curl
  - python3
---

# Skill Name

> Brief overview of the skill

## When to Use This Skill

Clear trigger conditions - when should the AI agent activate this skill?

## Setup Requirements

Any one-time setup needed (API keys, dependencies, etc.)

## Usage Instructions

Step-by-step instructions for the AI agent to follow

## Parameters

Input parameters the skill accepts

## Examples

Concrete examples of using the skill

## Error Handling

Common errors and how to handle them
```

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | ✅ Yes | Kebab-case skill identifier |
| `version` | ✅ Yes | Semantic version (1.0.0) |
| `description` | ✅ Yes | What the skill does and when to use it |
| `author` | ✅ Yes | Skill creator's name |
| `tags` | Recommended | Categories for discovery |
| `allowed-tools` | Optional | Restrict which tools can be used |
| `dependencies` | Recommended | External tools/packages needed |

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
2. **Write SKILL.md** with proper frontmatter
3. **Write README.md** for humans
4. **Add scripts** (if needed) in `scripts/` subfolder
5. **Add examples** in `examples/` subfolder
6. **Update catalog** - Add entry to `catalog/skills-index.json`
7. **Test thoroughly** before submitting

### Checklist for New Skills

- [ ] `SKILL.md` with valid frontmatter
- [ ] `README.md` with installation instructions
- [ ] No hardcoded credentials or secrets
- [ ] Scripts are executable and include shebang
- [ ] Examples demonstrate real usage
- [ ] Updated `catalog/skills-index.json`
- [ ] Tested locally

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
3. **Check requirements** - Verify dependencies are available
4. **Follow instructions** - Execute skill according to SKILL.md
5. **Handle errors** - Use error handling from skill documentation
6. **Report results** - Tell user what happened

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

### Claude Code
- Skills in `~/.claude/skills/`
- Reads SKILL.md frontmatter
- Loads skills based on description matching

### Cursor IDE
- Skills in `~/.cursor/skills/`
- Also supports `.cursor/rules/*.mdc` format
- Can convert SKILL.md to .mdc if needed

### Other Agents
- Follow SKILL.md format for best compatibility
- Check individual agent documentation for installation

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

Last updated: 2026-01-19
Version: 1.0.0
