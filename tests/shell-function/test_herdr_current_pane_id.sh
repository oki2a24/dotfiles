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
fi
EOF
chmod +x $tmpdir/herdr

source /Users/oki2a24/dotfiles/zsh/.zshrc_test_functions

result=$(PATH=$tmpdir:$PATH __herdr_current_pane_id 2>/dev/null)
if [[ "$result" == "w7:pK" ]]; then
  echo "PASS: __herdr_current_pane_id returns correct pane id"
else
  echo "FAIL: expected w7:pK, got $result"
  exit 1
fi
