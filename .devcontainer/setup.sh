#!/usr/bin/env bash
# Runs once when the Codespace is created.
# Installs the Codex CLI, sets Codex to the GPT-6 Luna model,
# and signs Codex in with the OPENAI_API_KEY Codespaces secret (if one was given).
# Claude Code needs no setup here: it reads ANTHROPIC_API_KEY on its own.

echo "== Setting up your coding agents =="

if ! command -v codex >/dev/null 2>&1; then
  npm install -g @openai/codex >/dev/null 2>&1 \
    && echo "Codex CLI installed." \
    || echo "Could not install the Codex CLI. Ask your teacher."
fi

mkdir -p "$HOME/.codex"
cat > "$HOME/.codex/config.toml" <<'EOF'
# Codex settings for this class
model = "gpt-6-luna"
approval_policy = "on-request"
sandbox_mode = "workspace-write"
EOF

if [ -n "${OPENAI_API_KEY:-}" ]; then
  if printenv OPENAI_API_KEY | codex login --with-api-key >/dev/null 2>&1; then
    echo "Codex: signed in with your group's key."
  else
    echo "Codex: sign-in failed. Check the OPENAI_API_KEY secret."
  fi
else
  echo "Codex: no OPENAI_API_KEY secret found. That's fine until the comparison activity."
fi

if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
  echo "Claude Code: key found. Open the Claude panel and approve the key when asked."
else
  echo "Claude Code: no ANTHROPIC_API_KEY secret found. Ask your teacher."
fi

echo "== Done =="
