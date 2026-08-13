#!/usr/bin/env zsh
set -euo pipefail

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

cat > $tmpdir/herdr <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "agent" && "$2" == "list" ]]; then
  cat <<'JSON'
{"result":{"agents":[{"pane_id":"w7:p1"},{"pane_id":"w7:pK"}]}}
JSON
fi
EOF
chmod +x $tmpdir/herdr

source /Users/oki2a24/dotfiles/zsh/.zshrc_test_functions



if PATH=$tmpdir:$PATH __herdr_pane_is_agent w7:pK; then
  echo "PASS: agent detected"
else
  echo "FAIL: agent not detected"
  exit 1
fi

if PATH=$tmpdir:$PATH __herdr_pane_is_agent w7:pX; then
  echo "FAIL: false positive"
  exit 1
else
  echo "PASS: non-agent correctly rejected"
fi
