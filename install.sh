#!/usr/bin/env bash
# Install the Mango skills for every Claude Code session on this machine.
#
#   ./install.sh            link skills into ~/.claude/skills (stays current with `git pull`)
#   ./install.sh --copy     copy instead of link (use in cloud setup scripts)
#   ./install.sh --update   git pull this repo first, then install
#   ./install.sh --no-mcp   skip registering MCP servers
#
# Safe to run again. A skill folder that already exists and isn't ours is moved
# to ~/.claude/skills/.mango-backup-<timestamp>/ before installing.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
MODE=link; UPDATE=0; MCP=1
for a in "$@"; do
  case "$a" in
    --copy) MODE=copy ;;
    --update) UPDATE=1 ;;
    --no-mcp) MCP=0 ;;
    -h|--help) sed -n '2,11p' "$0"; exit 0 ;;
    *) echo "Unknown option: $a" >&2; exit 2 ;;
  esac
done

if [ "$UPDATE" = 1 ]; then git -C "$REPO" pull --ff-only; fi

mkdir -p "$DEST"
STAMP="$(date +%Y%m%d-%H%M%S)"
installed=()
for src in "$REPO"/skills/*/; do
  name="$(basename "$src")"
  [ -f "$src/SKILL.md" ] || continue
  target="$DEST/$name"
  if [ -L "$target" ]; then
    rm "$target"
  elif [ -e "$target" ]; then
    if [ -f "$target/.mango-skill" ]; then
      rm -rf "$target"
    else
      mkdir -p "$DEST/.mango-backup-$STAMP"
      mv "$target" "$DEST/.mango-backup-$STAMP/$name"
      echo "Backed up your existing $name to $DEST/.mango-backup-$STAMP/"
    fi
  fi
  if [ "$MODE" = link ]; then
    ln -s "${src%/}" "$target"
  else
    cp -R "${src%/}" "$target"
    echo "installed by mango-skills on $STAMP" > "$target/.mango-skill"
  fi
  installed+=("$name")
done
echo "Installed ${#installed[@]} skills into $DEST ($MODE): ${installed[*]}"

if [ "$MCP" = 1 ]; then
  if command -v claude >/dev/null 2>&1; then
    add_mcp() {  # name, then the rest of `claude mcp add` arguments
      local name="$1"; shift
      # run from $HOME so a project's own .mcp.json can't hide a missing user-level server
      if (cd "$HOME" && claude mcp get "$name" 2>/dev/null | grep -qi "scope: user"); then
        echo "MCP server $name already registered"
      elif (cd "$HOME" && claude mcp add --scope user "$name" "$@" >/dev/null 2>&1); then
        echo "Registered MCP server $name"
      else
        echo "Could not register MCP server $name (skipped)"
      fi
    }
    add_mcp awwwards -- npx -y awwwards-mcp
    add_mcp rea -- npx -y rea-agents@6.8.0 mcp
    add_mcp taste-engine --transport http https://mcp.tastelabs.com/mcp
  else
    echo "Claude Code CLI not found: skipped MCP servers. Run this script again after installing it."
  fi
fi
echo "Done. Start a new Claude Code session to load the skills."
