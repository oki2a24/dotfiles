#!/usr/bin/env zsh
set -euo pipefail

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

cat > $tmpdir/codex <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@"
EOF
chmod +x $tmpdir/codex

cat > $tmpdir/claude <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@"
EOF
chmod +x $tmpdir/claude

run_test() {
  local name=$1
  local herdr_script=$2
  local cmd=$3
  local expected=$4
  
  cat > $tmpdir/herdr <<EOF
#!/usr/bin/env bash
$herdr_script
EOF
  chmod +x $tmpdir/herdr
  
  local result
  result=$(env -i HOME=$HOME PATH=$tmpdir:/bin:/usr/bin USER=$USER /bin/zsh -c "
    source /Users/oki2a24/dotfiles/zsh/.zshrc_test_functions
    $cmd
  ")
  
  if [[ "$result" == "$expected" ]]; then
    echo "PASS: $name"
  else
    echo "FAIL: $name expected '$expected', got '$result'"
    exit 1
  fi
}

# ペインがエージェントリストにない場合 → 通常実行
run_test "non-agent pane" 'cat <<JSON
{"result":{"pane_id":"w7:pX"}}
JSON' 'codex arg1' 'arg1'

# ペインがエージェントリストにある場合 → フラグ注入
run_test "agent pane codex" '
if [[ "$1" == "pane" ]]; then cat <<JSON
{"result":{"pane_id":"w7:pK"}}
JSON
elif [[ "$1" == "agent" ]]; then cat <<JSON
{"result":{"agents":[{"pane_id":"w7:p1"},{"pane_id":"w7:pK"}]}}
JSON
fi' 'codex arg1' $'--local-provider\nollama\narg1'

echo "All tests passed"
