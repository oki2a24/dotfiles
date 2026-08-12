# Herdr Agent 起動判定によるローカル LLM 強制ロジック Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Herdr Agent 起動時のみコード系コマンドに自動でローカル LLM プロバイダを強制注入するシェル関数を実装する。

**Architecture:** zsh/.zshrc に `codex`/`claude` ラッパーとヘルパーを追加。$HERDR_PANE_ID を取得し、herdr agent list JSON から pane_id 存在確認。マッチ時のみ --local-provider/--provider ollama を注入。

**Tech Stack:** zsh, jq, herdr CLI, TDD シェルテスト

---

### Task 1: テスト用ヘルパーと Red フェーズのテスト作成

**Files:**
- Create: `tests/shell-function/test_herdr_agent_local_llm.sh`
- Modify: `zsh/.zshrc` (後で)

- [ ] **Step 1: Write the failing test**

```sh
#!/usr/bin/env zsh
set -euo pipefail

source /Users/oki2a24/dotfiles/zsh/.zshrc

tmpdir=$(mktemp -d)
cat > $tmpdir/codex <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@"
EOF
chmod +x $tmpdir/codex
export PATH=$tmpdir:$PATH

unset HERDR_PANE_ID
result=$(codex arg1)
if [[ "$result" != "arg1" ]]; then
  echo "FAIL: unset HERDR_PANE_ID expected 'arg1', got '$result'"
  exit 1
fi
echo "PASS unset"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `zsh tests/shell-function/test_herdr_agent_local_llm.sh`
Expected: FAIL with command not found or wrong args

### Task 2: zsh/.zshrc に最小実装 (Green)

**Files:**
- Modify: `zsh/.zshrc`

- [ ] **Step 1: Write minimal implementation**

```zsh
__run_with_provider_if_herdr() {
  local cmd=$1 provider_flag=$2
  shift 2
  if [[ -z ${HERDR_PANE_ID:-} ]]; then
    command "$cmd" "$@"
    return
  fi
  # herdr agent list から pane_id を取得
  local pane_ids
  pane_ids=$(herdr agent list 2>/dev/null | jq -r '.result.agents[].pane_id' 2>/dev/null)
  if echo "$pane_ids" | grep -qx "$HERDR_PANE_ID"; then
    command "$cmd" "$provider_flag" "$@"
  else
    command "$cmd" "$@"
  fi
}

codex() { __run_with_provider_if_herdr codex --local-provider ollama "$@"; }
claude() { __run_with_provider_if_herdr claude --provider ollama "$@"; }
```

- [ ] **Step 2: Run test to verify it passes**

Run: `zsh tests/shell-function/test_herdr_agent_local_llm.sh`
Expected: PASS unset

### Task 3: pane ID マッチ時のテスト追加と Red-Green

**Files:**
- Modify: `tests/shell-function/test_herdr_agent_local_llm.sh`

- [ ] **Step 1: Write failing test for pane match**

```sh
# herdr コマンドをモック
tmpdir=$(mktemp -d)
cat > $tmpdir/herdr <<'EOF'
#!/usr/bin/env bash
cat <<'JSON'
{"result":{"agents":[{"pane_id":"w7:p1"},{"pane_id":"w7:pC"}]}}
JSON
EOF
chmod +x $tmpdir/herdr
export PATH=$tmpdir:$PATH

export HERDR_PANE_ID=w7:p1
result=$(codex arg1)
expected="--local-provider ollama arg1"
if [[ "$result" != "$expected" ]]; then
  echo "FAIL: pane match expected '$expected', got '$result'"
  exit 1
fi
echo "PASS pane match"
```

- [ ] **Step 2: Run test to verify it passes**

Run: `zsh tests/shell-function/test_herdr_agent_local_llm.sh`
Expected: PASS pane match

### Task 4: pane ID 非マッチとエラーケースのテスト追加

**Files:**
- Modify: `tests/shell-function/test_herdr_agent_local_llm.sh`

- [ ] **Step 1: Write edge case tests**

```sh
export HERDR_PANE_ID=nonexistent
result=$(claude a b)
expected="a b"
if [[ "$result" != "$expected" ]]; then
  echo "FAIL: pane mismatch expected '$expected', got '$result'"
  exit 1
fi
echo "PASS pane mismatch"

# herdr コマンド失敗時のテスト
cat > $tmpdir/herdr <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
chmod +x $tmpdir/herdr
export HERDR_PANE_ID=w7:p1
result=$(codex x)
expected="x"
if [[ "$result" != "$expected" ]]; then
  echo "FAIL: herdr fail expected '$expected', got '$result'"
  exit 1
fi
echo "PASS herdr fail"
```

- [ ] **Step 2: Run tests to verify they pass**

Run: `zsh tests/shell-function/test_herdr_agent_local_llm.sh`
Expected: PASS pane mismatch, PASS herdr fail

### Task 5: claude 専用テストとリファクタリング

**Files:**
- Modify: `tests/shell-function/test_herdr_agent_local_llm.sh`
- Modify: `zsh/.zshrc`

- [ ] **Step 1: Add claude test**

```sh
cat > $tmpdir/claude <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@"
EOF
chmod +x $tmpdir/claude

cat > $tmpdir/herdr <<'EOF'
#!/usr/bin/env bash
cat <<'JSON'
{"result":{"agents":[{"pane_id":"w7:p1"}]}}
JSON
EOF
chmod +x $tmpdir/herdr

export HERDR_PANE_ID=w7:p1
result=$(claude a b)
expected="--provider ollama a b"
if [[ "$result" != "$expected" ]]; then
  echo "FAIL: claude expected '$expected', got '$result'"
  exit 1
fi
echo "PASS claude"
```

- [ ] **Step 2: Refactor helper to avoid double herdr call**

```zsh
__herdr_pane_exists() {
  local target=$1
  local pane_ids
  pane_ids=$(herdr agent list 2>/dev/null | jq -r '.result.agents[].pane_id' 2>/dev/null)
  [[ -n $pane_ids ]] && echo "$pane_ids" | grep -qx "$target"
}
```

- [ ] **Step 3: Run all tests**

Run: `zsh tests/shell-function/test_herdr_agent_local_llm.sh`
Expected: All PASS

### Task 6: コミット

**Files:**
- Modify: `zsh/.zshrc`
- Create: `tests/shell-function/test_herdr_agent_local_llm.sh`

- [ ] **Step 1: Commit**

```bash
git add zsh/.zshrc tests/shell-function/test_herdr_agent_local_llm.sh
git commit -m "feat: add Herdr Agent local LLM forcing logic with TDD"
```
