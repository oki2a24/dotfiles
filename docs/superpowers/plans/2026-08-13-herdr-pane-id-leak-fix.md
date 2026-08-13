# HERDR_PANE_ID リーク修正 実装計画

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** HERDR_PANE_ID 環境変数のリークを解消し、Herdr API からリアルタイムにペイン ID を取得してエージェント判定を行う

**Architecture:** zsh ラッパー関数で `herdr pane current --current` と `herdr agent list` を組み合わせ、環境変数依存を排除。TDD でテスト作成後実装

**Tech Stack:** zsh, herdr CLI, jq

---

### Task 1: 実装ファイル構造の確認

**Files:**
- Modify: `/Users/oki2a24/dotfiles/zsh/.zshrc`
- Modify: `/Users/oki2a24/dotfiles/zsh/.zshrc_test_functions`
- Test: `/Users/oki2a24/dotfiles/tests/shell-function/test_herdr_agent_local_llm.sh`

- [ ] **Step 1: 既存コードを確認**
```bash
read /Users/oki2a24/dotfiles/zsh/.zshrc
```
Expected: __herdr_pane_exists, __run_with_provider_if_herdr が存在

- [ ] **Step 2: テストファイル確認**
```bash
read /Users/oki2a24/dotfiles/tests/shell-function/test_herdr_agent_local_llm.sh
```
Expected: HERDR_PANE_ID を使用したテストが存在

---

### Task 2: __herdr_current_pane_id ヘルパーのテスト作成

**Files:**
- Create: `/Users/oki2a24/dotfiles/tests/shell-function/test_herdr_current_pane_id.sh`

- [ ] **Step 1: 失敗するテストを書く**
```bash
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

__herdr_current_pane_id() {
  local pane_id
  pane_id=$(herdr pane current --current 2>/dev/null | jq -r '.result.pane_id // empty')
  echo "$pane_id"
}

result=$(PATH=$tmpdir:$PATH __herdr_current_pane_id)
if [[ "$result" == "w7:pK" ]]; then
  echo "PASS"
else
  echo "FAIL: expected w7:pK, got $result"
  exit 1
fi
```

- [ ] **Step 2: テスト実行して失敗確認**
```bash
zsh /Users/oki2a24/dotfiles/tests/shell-function/test_herdr_current_pane_id.sh
```
Expected: FAIL (関数未実装のため)

---

### Task 3: __herdr_current_pane_id 実装

**Files:**
- Modify: `/Users/oki2a24/dotfiles/zsh/.zshrc_test_functions`

- [ ] **Step 1: 最小実装**
```zsh
__herdr_current_pane_id() {
  local pane_id
  pane_id=$(herdr pane current --current 2>/dev/null | jq -r '.result.pane_id // empty' 2>/dev/null)
  if [[ -z $pane_id ]]; then
    return 1
  fi
  echo "$pane_id"
}
```

- [ ] **Step 2: テスト実行**
```bash
zsh /Users/oki2a24/dotfiles/tests/shell-function/test_herdr_current_pane_id.sh
```
Expected: PASS

- [ ] **Step 3: コミット**
```bash
git add tests/shell-function/test_herdr_current_pane_id.sh zsh/.zshrc_test_functions
git commit -m "test: __herdr_current_pane_id のテストを追加"
```

---

### Task 4: __herdr_pane_is_agent ヘルパーのテスト作成

**Files:**
- Create: `/Users/oki2a24/dotfiles/tests/shell-function/test_herdr_pane_is_agent.sh`

- [ ] **Step 1: 失敗するテスト**
```bash
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

__herdr_pane_is_agent() {
  local pane_id=$1
  local agents
  agents=$(herdr agent list 2>/dev/null | jq -r '.result.agents[].pane_id' 2>/dev/null)
  [[ -n $agents ]] && printf '%s\n' "$agents" | grep -Fxq "$pane_id"
}

if __herdr_pane_is_agent w7:pK; then
  echo "PASS: agent detected"
else
  echo "FAIL: agent not detected"
  exit 1
fi

if __herdr_pane_is_agent w7:pX; then
  echo "FAIL: false positive"
  exit 1
else
  echo "PASS: non-agent correctly rejected"
fi
```

- [ ] **Step 2: テスト実行**
```bash
zsh /Users/oki2a24/dotfiles/tests/shell-function/test_herdr_pane_is_agent.sh
```
Expected: FAIL

---

### Task 5: __herdr_pane_is_agent 実装

**Files:**
- Modify: `/Users/oki2a24/dotfiles/zsh/.zshrc_test_functions`

- [ ] **Step 1: 最小実装**
```zsh
__herdr_pane_is_agent() {
  local pane_id=$1
  if [[ -z $pane_id ]]; then
    return 1
  fi
  local agents
  agents=$(herdr agent list 2>/dev/null | jq -r '.result.agents[].pane_id' 2>/dev/null)
  [[ -n $agents ]] && printf '%s\n' "$agents" | grep -Fxq "$pane_id"
}
```

- [ ] **Step 2: テスト実行**
```bash
zsh /Users/oki2a24/dotfiles/tests/shell-function/test_herdr_pane_is_agent.sh
```
Expected: PASS

- [ ] **Step 3: コミット**
```bash
git add tests/shell-function/test_herdr_pane_is_agent.sh zsh/.zshrc_test_functions
git commit -m "test: __herdr_pane_is_agent のテストを追加"
```

---

### Task 6: 環境変数不要化の統合テスト

**Files:**
- Create: `/Users/oki2a24/dotfiles/tests/shell-function/test_herdr_no_env.sh`

- [ ] **Step 1: テスト作成**
```bash
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

# 環境変数 HERDR_PANE_ID を未設定のまま動作確認
unset HERDR_PANE_ID
result=$(PATH=$tmpdir:$PATH __run_with_provider_if_herdr codex --local-provider ollama arg1)
expected=$'--local-provider\nollama\narg1'
if [[ "$result" == "$expected" ]]; then
  echo "PASS: 環境変数不要で動作"
else
  echo "FAIL: expected '$expected', got '$result'"
  exit 1
fi
```

- [ ] **Step 2: テスト実行**
```bash
zsh /Users/oki2a24/dotfiles/tests/shell-function/test_herdr_no_env.sh
```
Expected: FAIL (未実装)

---

### Task 7: __run_with_provider_if_herdr リファクタリング

**Files:**
- Modify: `/Users/oki2a24/dotfiles/zsh/.zshrc_test_functions`

- [ ] **Step 1: API ベースに変更**
```zsh
__run_with_provider_if_herdr() {
  local cmd=$1 provider_flag=$2 provider_val=$3
  shift 3
  local pane_id
  pane_id=$(__herdr_current_pane_id 2>/dev/null)
  if [[ -z $pane_id ]]; then
    command "$cmd" "$@"
    return
  fi
  if __herdr_pane_is_agent "$pane_id"; then
    command "$cmd" "$provider_flag" "$provider_val" "$@"
  else
    command "$cmd" "$@"
  fi
}
```

- [ ] **Step 2: テスト実行**
```bash
zsh /Users/oki2a24/dotfiles/tests/shell-function/test_herdr_no_env.sh
```
Expected: PASS

- [ ] **Step 3: コミット**
```bash
git add tests/shell-function/test_herdr_no_env.sh zsh/.zshrc_test_functions
git commit -m "feat: HERDR_PANE_ID 環境変数依存を排除し API ベースに変更"
```

---

### Task 8: 既存テストの更新

**Files:**
- Modify: `/Users/oki2a24/dotfiles/tests/shell-function/test_herdr_agent_local_llm.sh`

- [ ] **Step 1: テスト内容変更**
```bash
# 旧: HERDR_PANE_ID 環境変数設定
# 新: herdr コマンドモックでペイン ID を返却

run_test "unset HERDR_PANE_ID" "" "codex arg1" "arg1"
# -> ペイン current がエージェントでない場合のテストに変更

cat > $tmpdir/herdr <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == "pane" && "$2" == "current" ]]; then
  cat <<'JSON'
{"result":{"pane_id":"w7:pX"}}
JSON
elif [[ "$1" == "agent" && "$2" == "list" ]]; then
  cat <<'JSON'
{"result":{"agents":[{"pane_id":"w7:p1"}]}}
JSON
fi
EOF
```

- [ ] **Step 2: テスト実行**
```bash
zsh /Users/oki2a24/dotfiles/tests/shell-function/test_herdr_agent_local_llm.sh
```
Expected: PASS

- [ ] **Step 3: コミット**
```bash
git add tests/shell-function/test_herdr_agent_local_llm.sh
git commit -m "test: 既存テストを API ベースに更新"
```

---

### Task 9: メイン実装ファイルへの反映

**Files:**
- Modify: `/Users/oki2a24/dotfiles/zsh/.zshrc`

- [ ] **Step 1: 実装反映**
```zsh
__herdr_current_pane_id() {
  local pane_id
  pane_id=$(herdr pane current --current 2>/dev/null | jq -r '.result.pane_id // empty' 2>/dev/null)
  if [[ -z $pane_id ]]; then
    return 1
  fi
  echo "$pane_id"
}

__herdr_pane_is_agent() {
  local pane_id=$1
  if [[ -z $pane_id ]]; then
    return 1
  fi
  local agents
  agents=$(herdr agent list 2>/dev/null | jq -r '.result.agents[].pane_id' 2>/dev/null)
  [[ -n $agents ]] && printf '%s\n' "$agents" | grep -Fxq "$pane_id"
}

__run_with_provider_if_herdr() {
  local cmd=$1 provider_flag=$2 provider_val=$3
  shift 3
  local pane_id
  pane_id=$(__herdr_current_pane_id 2>/dev/null)
  if [[ -z $pane_id ]]; then
    command "$cmd" "$@"
    return
  fi
  if __herdr_pane_is_agent "$pane_id"; then
    command "$cmd" "$provider_flag" "$provider_val" "$@"
  else
    command "$cmd" "$@"
  fi
}
```

- [ ] **Step 2: コミット**
```bash
git add zsh/.zshrc
git commit -m "feat: HERDR_PANE_ID リーク修正を本番ファイルに反映"
```

---

### Task 10: 最終検証

**Files:**
- Run: `tests/shell-function/test_herdr_agent_local_llm.sh`

- [ ] **Step 1: 全テスト実行**
```bash
zsh tests/shell-function/test_herdr_agent_local_llm.sh
```
Expected: All tests passed

- [ ] **Step 2: リント確認**
```bash
# zsh syntax check
zsh -n zsh/.zshrc
```
Expected: No errors

- [ ] **Step 3: コミット**
```bash
git commit -m "chore: HERDR_PANE_ID リーク修正完了"
```

---
