#!/bin/sh
# Skill context that needs ${VAR:-default}, which Claude Code won't run inline in a skill.
case "$1" in
  vault) echo "${BRAIN_DIR:-$HOME/brain}" ;;
  ext) cat "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/workflow/$2.md" 2>/dev/null || echo "(none)" ;;
esac
