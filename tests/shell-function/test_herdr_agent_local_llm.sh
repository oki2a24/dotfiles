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

cat > $tmpdir/herdr <<'EOF'
#!/usr/bin/env bash
cat <<'JSON'
{"result":{"agents":[{"pane_id":"w7:p1"},{"pane_id":"w7:pC"}]}}
JSON
EOF
chmod +x $tmpdir/herdr

run_test() {
  local name=$1
  local env_set=$2
  local cmd=$3
  local expected=$4
  
  local result
  if [[ -n $env_set ]]; then
    result=$(env -i HOME=$HOME PATH=$tmpdir:/bin:/usr/bin USER=$USER $env_set /bin/zsh -c "
      source /Users/oki2a24/dotfiles/zsh/.zshrc_test_functions
      $cmd
    ")
  else
    result=$(env -i HOME=$HOME PATH=$tmpdir:/bin:/usr/bin USER=$USER /bin/zsh -c "
      source /Users/oki2a24/dotfiles/zsh/.zshrc_test_functions
      $cmd
    ")
  fi
  
  if [[ "$result" == "$expected" ]]; then
    echo "PASS: $name"
  else
    echo "FAIL: $name expected '$expected', got '$result'"
    exit 1
  fi
}

run_test "unset HERDR_PANE_ID" "" "codex arg1" "arg1"
run_test "matching pane ID codex" "HERDR_PANE_ID=w7:p1" "codex arg1" $'--local-provider\nollama\narg1'
run_test "non-matching pane ID" "HERDR_PANE_ID=nonexistent" "claude a b" $'a\nb'
run_test "matching pane ID claude" "HERDR_PANE_ID=w7:pC" "claude a b" $'--provider\nollama\na\nb'
run_test "herdr fail" "HERDR_PANE_ID=w7:p1 HERDR_FAIL=1" "codex x" "x"

echo "All tests passed"
