# Free AI Agent Skills

> A curated collection of production-ready skills for AI coding agents like Claude Code, Cursor, and other AI development tools.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Skills](https://img.shields.io/badge/skills-1-green.svg)](./skills)
[![Compatible](https://img.shields.io/badge/compatible-Claude%20Code%20%7C%20Cursor-orange.svg)]()

---

## 🎯 What is This?

Free AI Agent Skills is an open-source library of reusable skills that extend the capabilities of AI coding agents. Each skill is:

- ✅ **Universal Format** - Works with Claude Code, Cursor IDE, and other AI agents
- ✅ **Production Ready** - Tested, documented, and battle-hardened
- ✅ **Self-Contained** - No dependencies on proprietary systems
- ✅ **Free & Open** - MIT licensed for unrestricted use
- ✅ **Secure** - No hardcoded credentials or API keys

---

## 📚 Available Skills

### 🎨 [Gemini Image Generation](./skills/gemini-image-generation/)

Generate professional images using Google's Gemini 3 Pro and Gemini 2.0 Flash models.

**Features:**
- Two model options (Pro for quality, Flash for speed)
- Custom aspect ratios (1:1, 16:9, 9:16, etc.)
- Multiple resolutions (1K, 2K, 4K)
- Reference image support
- Google Search grounding

**Perfect for:** Logos, banners, social media graphics, UI mockups

[→ Read Full Documentation](./skills/gemini-image-generation/)

---

## 🚀 Quick Start

### For Claude Code

```bash
# Clone the repository
git clone https://github.com/chirag2653/free-ai-agent-skills.git

# Symlink the skill you want
ln -s "$(pwd)/free-ai-agent-skills/skills/gemini-image-generation" ~/.claude/skills/
```

### For Cursor IDE

```bash
# Clone the repository
git clone https://github.com/chirag2653/free-ai-agent-skills.git

# Symlink the skill you want
ln -s "$(pwd)/free-ai-agent-skills/skills/gemini-image-generation" ~/.cursor/skills/
```

### Windows (PowerShell)

```powershell
# Clone the repository
git clone https://github.com/chirag2653/free-ai-agent-skills.git

# Copy the skill folder
Copy-Item -Recurse "free-ai-agent-skills\skills\gemini-image-generation" "$env:USERPROFILE\.claude\skills\"
# or for Cursor
Copy-Item -Recurse "free-ai-agent-skills\skills\gemini-image-generation" "$env:USERPROFILE\.cursor\skills\"
```

### That's It!

The skill's `SKILL.md` contains all the instructions your AI agent needs. Just mention "Gemini" when you want to generate an image.

---

## 📖 How Skills Work

Each skill is a simple folder with everything your AI agent needs:

```
skill-name/
├── SKILL.md           # Instructions for AI agents (frontmatter + markdown)
└── scripts/           # Executable scripts (if needed)
```

**That's it!** The `SKILL.md` file contains:
- Metadata (name, version, description, author)
- When to activate the skill
- Interactive workflow for the AI agent
- All instructions needed to use the skill

This format works with:
- **Claude Code** (Anthropic)
- **Cursor IDE** 
- **Any AI agent** supporting the SKILL.md format

---

## 🔍 Browse Skills

View the [Skills Catalog](./catalog/skills-index.json) for a machine-readable index of all available skills.

---

## 🤝 Contributing

Have a useful skill for AI agents? Share it here!

**Simple contribution process:**
1. Fork this repository
2. Create a new folder under `skills/your-skill-name/`
3. Add `SKILL.md` with frontmatter metadata and instructions
4. Add your scripts (if needed) in `scripts/` subfolder
5. Update `catalog/skills-index.json`
6. Submit a pull request

**Requirements:**
- ✅ SKILL.md with proper frontmatter
- ✅ No hardcoded credentials or API keys
- ✅ Works across multiple AI agents (Claude Code, Cursor, etc.)
- ✅ MIT or compatible license

---

## 🛠️ For AI Agents

If you're an AI agent reading this:

1. Check [AGENTS.md](./AGENTS.md) for repository guidelines
2. Skills are in the `skills/` directory
3. Each skill has a `SKILL.md` with complete instructions
4. The `catalog/skills-index.json` provides a searchable catalog

---

## 📄 License

This repository is licensed under the **MIT License** - see [LICENSE](./LICENSE) for details.

Individual skills may include additional attributions or dependencies with their own licenses.

---

## 👤 Author & Maintainer

**Chirag Jain**
- GitHub: [@chirag2653](https://github.com/chirag2653)
- Email: chirag2356152@gmail.com

---

## 🗺️ Roadmap

- [x] Gemini Image Generation skill
- [ ] More image/media skills
- [ ] Database and API integration skills
- [ ] Code analysis and refactoring skills
- [ ] Automated skill validation

---

## 💬 Support & Community

- **Issues**: Found a bug? [Open an issue](https://github.com/chirag2653/free-ai-agent-skills/issues)
- **Discussions**: Questions or ideas? Start a [discussion](https://github.com/chirag2653/free-ai-agent-skills/discussions)
- **Pull Requests**: Want to contribute? We review PRs regularly

---

**Made with ❤️ for the AI agent community**
