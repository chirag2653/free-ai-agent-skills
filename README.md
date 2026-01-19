# Free AI Agent Skills

> A curated collection of production-ready skills for any AI agent that supports the SKILL.md standard - from coding to marketing, design, and beyond.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Skills](https://img.shields.io/badge/skills-1-green.svg)](./skills)
[![Compatible](https://img.shields.io/badge/compatible-Cursor%20%7C%20Claude%20%7C%20Codex%20%7C%20Gemini-orange.svg)]()

---

## 🎯 What is This?

Free AI Agent Skills is an open-source library of reusable skills that extend the capabilities of any AI agent. Each skill is:

- ✅ **Universal SKILL.md Standard** - Works with any agent supporting the format (Cursor, Claude Code, Codex, Gemini CLI, etc.)
- ✅ **Project-Aware** - Uses your project's API keys and environment automatically
- ✅ **Production Ready** - Tested, documented, and battle-hardened
- ✅ **Agent-Agnostic** - Works for coding, marketing, design, writing agents - any AI agent
- ✅ **Secure** - No hardcoded credentials, pulls from your project's .env files

---

## 📚 Available Skills

### 🎨 [Gemini Image Generation](./skills/gemini-image-generation/)

Generate professional images using Google's Gemini 3 Pro and Gemini 2.5 Flash models.

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

**Simple 3-step process:**

1. **Clone this repository:**
   ```bash
   git clone https://github.com/chirag2653/free-ai-agent-skills.git
   ```

2. **Install the skill to your AI agent's directory:**
   - **Cursor**: `~/.cursor/skills/` (or `%USERPROFILE%\.cursor\skills\` on Windows)
   - **Claude Code**: `~/.claude/skills/`
   - **Codex**: `~/.codex/skills/`
   - **Other agents**: Check your agent's documentation for the skills directory

   Copy or symlink the skill folder there.

3. **That's it!** Your AI agent will automatically detect and use the skill.

### The Real Power

Add your API keys to your project's `.env.local` file:

```bash
GEMINI_API_KEY=your-key-here
```

Now any AI agent working in your project folder can generate images directly - no separate configuration needed!

---

## 📖 How Skills Work

Skills use the universal **SKILL.md standard** - a simple format that any AI agent can understand:

```
skill-name/
├── SKILL.md           # Instructions for AI agents (frontmatter + markdown)
└── scripts/           # Executable scripts (if needed)
```

**The Magic:**
1. **Project-Aware**: Skills read API keys and config from your project's `.env` files
2. **Agent-Agnostic**: Works with any AI agent that supports skills (coding, marketing, design, writing agents)
3. **Zero Configuration**: Agent auto-detects skills, pulls credentials from your project
4. **Universal Format**: One skill works across Cursor, Claude Code, Codex, Gemini CLI, and more

**Example Use Cases:**
- 🖥️ **Coding agent** generates UI mockups in your app's `public/images/` folder
- 📱 **Marketing agent** creates social media graphics with your brand assets
- 📝 **Writing agent** generates illustrations for blog posts in your content folder
- 🎨 **Design agent** prototypes icons and banners using project style guides

---

## 🔍 Browse Skills

View the [Skills Catalog](./catalog/skills-index.json) for a machine-readable index of all available skills.

---

## 🤝 Contributing

Have a useful skill for AI agents? Share it here! Skills can be for any domain - coding, marketing, design, data analysis, writing, research, etc.

**Simple contribution process:**
1. Fork this repository
2. Create a new folder under `skills/your-skill-name/`
3. Add `SKILL.md` with frontmatter metadata and instructions
4. Add your scripts (if needed) in `scripts/` subfolder
5. Update `catalog/skills-index.json`
6. Submit a pull request

**Requirements:**
- ✅ Uses the SKILL.md standard format
- ✅ No hardcoded credentials - reads from project's `.env` files
- ✅ Works across any AI agent supporting the SKILL.md format
- ✅ Clear value proposition for any agent type (not just coding)
- ✅ MIT or compatible license

---

## 🛠️ For AI Agents

If you're an AI agent reading this (coding, marketing, design, writing - any domain):

1. Check [AGENTS.md](./AGENTS.md) for repository guidelines
2. Skills are in the `skills/` directory - you can use them in any project folder
3. Each skill has a `SKILL.md` with complete instructions
4. Skills automatically use the project's API keys from `.env.local` or `.env` files
5. The `catalog/skills-index.json` provides a searchable catalog

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
