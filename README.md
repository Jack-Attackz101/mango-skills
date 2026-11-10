# Mango skills

The Mango Studios skill set for Claude Code. Install once and every Claude Code session on that machine or cloud environment gets these commands.

| Command | What it does |
|---|---|
| `/design` | Super Design: art direction, build or redesign, then a judge AI scores and critiques it while the builder fixes issues until it reaches 8/10 |
| `/landing-page` | Landing pages and marketing sites: intake, structure, conversion copy, strict visual system, then the judge loop |
| `/prototype` | A gallery of full-page versions of your site in different themes, each openable full screen |
| `/scroll-site` | Cinematic scroll-driven sites: smooth scroll, pinned scenes, scrubbed sequences |
| `/animate` | All motion that isn't scroll: micro-interactions, cursor effects, particles, shaders, globes, motion review |
| `/image` | Generate hero art and assets, or source real photos and logos |
| `/brand` | Brand kits and design systems |
| `/review` | A graded report using the same rubric and judge as `/design`, plus extra audits |
| `/demo` | Faux product UI, recorded walkthroughs, page-to-video, voiceover |
| `/marketing` | Campaigns, competitor briefs, posts, emails, SEO, brand voice checks, reports |
| `/interview` | Interviews you in depth, then writes a spec to `.plans/` |
| `/agentation` | Adds the Agentation feedback toolbar to a Next.js app |
| `/reverse-engineer-anything` | REA reverse-engineering tools |

Each big skill keeps the original skills it merged as modules under `modules/`, with their credits and licenses in `SOURCES.md`.

## Install on your computer (Claude Code CLI, desktop app, VS Code, JetBrains)

```bash
git clone https://github.com/Jack-Attackz101/mango-skills.git ~/mango-skills
~/mango-skills/install.sh
```

This links every skill into `~/.claude/skills` and registers the awwwards, REA and taste-engine MCP servers at user level. Start a new session afterwards.

Update later with `~/mango-skills/install.sh --update`.

If you already had a skill with the same name, the installer moves it to `~/.claude/skills/.mango-backup-<timestamp>/` instead of deleting it.

## Install in Claude Code cloud sessions (claude.ai/code, mobile)

Do this once per cloud environment:

1. Open the environment menu in a session's title bar, then **Edit**.
2. Under **Repositories**, add `Jack-Attackz101/mango-skills` (it's private, so the setup script can only clone it once it's listed here).
3. Under **Setup script**, add:

```bash
if [ ! -d /tmp/mango-skills ]; then git clone --depth 1 https://github.com/Jack-Attackz101/mango-skills.git /tmp/mango-skills; fi
bash /tmp/mango-skills/install.sh --copy
```

4. Start a new session. The skills load in every repo that uses this environment.

## Claude.ai chat and the Claude desktop app chat

Chat doesn't read Claude Code skill folders. Upload skills one at a time instead:

```bash
./make-zips.sh   # builds dist/<skill>.zip
```

Then in Claude.ai: Settings, Capabilities, Skills, upload the zips you want. The big skills are large (`design` about 20 MB, `prototype` about 24 MB) because they carry their modules' demo assets, so start with the ones you use most.

## Requirements

- REA needs Node.js 22.23.4 or newer.
- Screenshot and video modules need Playwright and ffmpeg.
- awwwards and taste-engine need their domains allowed in a cloud environment's network settings; taste-engine also needs a sign-in.
