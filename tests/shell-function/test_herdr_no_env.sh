#!/usr/bin/env zsh
set -euo pipefail

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

cat > $tmpdir/herdr <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "pane" && "$2" == "current" ]]; then
  cat <<'JSON'
{"result":{"pane_id":"w7:pK"}}
JSON
elif [[ "$1" == "agent" && "$2" == "list" ]]; then
  cat <<'JSON'
{"result":{"agents":[{"pane_id":"w7:p1"},{"pane_id":"w7:pK"}]}}
JSON
fi
EOF
chmod +x $tmpdir/herdr

cat > $tmpdir/codex <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@"
EOF
chmod +x $tmpdir/codex

source /Users/oki2a24/dotfiles/zsh/.zshrc_test_functions

unset HERDR_PANE_ID
result=$(PATH=$tmpdir:$PATH __run_with_provider_if_herdr codex --local-provider ollama arg1)
expected=$'--local-provider\nollama\narg1'
if [[ "$result" == "$expected" ]]; then
  echo "PASS: 環境変数不要で動作"
else
  echo "FAIL: expected '$expected', got '$result'"
  exit 1
fi
