#!/usr/bin/env bash
# glm-test.sh — launch Claude Code against GLM-5.2 (via Z.ai's Anthropic-compatible endpoint)
# for throwaway testing, WITHOUT touching your global ~/.claude/settings.json.
#
# Usage:
#   ./glm-test.sh                 # launch claude in GLM mode
#   ./glm-test.sh -- <args>       # pass extra args straight through to claude
#
# Your normal terminals stay on Anthropic/Opus. Only the `claude` process this
# script spawns sees the GLM env vars.
#
# ============================================================================
# WORKSHOP QUICK START — new to this script? Do these 3 steps once.
# ============================================================================
#
# STEP 1 — Get a Z.ai API key (one-time, ~2 minutes)
#   a. Open https://z.ai/chat and click "Log in" (top-right). Register with
#      your email or a Google account — signing up is free.
#   b. Click your profile menu (top-right) and choose "API Keys"
#      (direct link: https://z.ai/manage-apikey/apikey-list).
#   c. Click "Create a new API key", name it (e.g. "workshop"), then copy
#      the key string. You can return to this page and copy it again later.
#   - Free for light testing: registered users get GLM-4.7-Flash and
#     GLM-4.5-Flash at no cost. For steady use, a GLM Coding Plan starts at
#     ~$10/month: https://z.ai/manage-apikey/billing
#   - NEVER paste the key into this file or commit it anywhere public.
#
# STEP 2 — Give the key to this script (pick ONE)
#   Quick, current terminal only:
#       export ZAI_API_KEY=paste_your_key_here
#   Persistent, reused on every run (recommended):
#       mkdir -p ~/.config/zai
#       printf '%s' 'paste_your_key_here' > ~/.config/zai/key
#       chmod 600 ~/.config/zai/key
#
# STEP 3 — Make it executable (first time only), then run it
#       cd <folder that contains this script>
#       chmod +x glm-test.sh        # needed once
#       ./glm-test.sh               # launches Claude Code on GLM-5.2
#   Pass extra arguments through to claude after a "--":
#       ./glm-test.sh -- --help
#   Inside the session, type /exit to quit. Your other terminals stay on
#   Anthropic/Opus — only the process this script starts talks to GLM.
# ============================================================================
#
set -euo pipefail

# --- API key (kept OUT of this script) -------------------------------------
# The key is read from, in order of preference:
#   1) the ZAI_API_KEY environment variable, if already exported
#   2) the file ~/.config/zai/key  (chmod 600 it; one line, just the key)
# This avoids hardcoding the secret in a file you might share or commit.
KEY_FILE="${HOME}/.config/zai/key"
ZAI_API_KEY="${ZAI_API_KEY:-}"                       # use exported var if present
if [[ -z "${ZAI_API_KEY}" && -f "${KEY_FILE}" ]]; then
  ZAI_API_KEY="$(tr -d '[:space:]' < "${KEY_FILE}")" # strip any stray whitespace/newline
fi
if [[ -z "${ZAI_API_KEY}" ]]; then                   # fail loudly rather than launch keyless
  echo "ERROR: no Z.ai API key found." >&2
  echo "  Either:  export ZAI_API_KEY=your_key   before running this," >&2
  echo "  or:      mkdir -p ~/.config/zai && printf '%s' 'your_key' > ${KEY_FILE} && chmod 600 ${KEY_FILE}" >&2
  exit 1
fi

# --- point Claude Code at GLM ----------------------------------------------
export ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic"   # Z.ai Anthropic-compatible gateway
export ANTHROPIC_AUTH_TOKEN="${ZAI_API_KEY}"                 # Z.ai uses bearer AUTH_TOKEN, not API_KEY
export ANTHROPIC_DEFAULT_OPUS_MODEL="glm-5.2"                # map the "opus" tier -> GLM-5.2
export ANTHROPIC_DEFAULT_SONNET_MODEL="glm-5.2"              # map the "sonnet" tier -> GLM-5.2
export ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-5.2"              # map small/background calls -> GLM-5.2
export API_TIMEOUT_MS="3000000"                              # GLM long-horizon calls can run long
unset ANTHROPIC_API_KEY                                      # prevent a stray ANTHROPIC_API_KEY overriding AUTH_TOKEN

echo "Launching Claude Code on GLM-5.2 (endpoint: ${ANTHROPIC_BASE_URL})" >&2
echo "Note: the /model UI may still show Claude labels — the served model is GLM-5.2." >&2

# Drop a leading "--" separator if the caller used one, then exec claude.
# exec replaces this script with claude, so the GLM env vars are scoped to that process only.
if [[ "${1:-}" == "--" ]]; then shift; fi
exec claude "$@"
