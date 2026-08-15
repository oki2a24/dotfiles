# シェル関数分離 実装計画

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** zsh の `codex`、`claude`、`pi` コマンドを関数化し、HERDR_ENV=1 時は自動で `--provider ollama` を付与する。

**Architecture:** `.zshrc` に三つのラッパー関数と共通ヘルパーを追加。HERDR_ENV 判定は `-n $HERDR_ENV && $HERDR_ENV == 1` で行う。`command` 呼び出しで実体バイナリを実行。

**Tech Stack:** zsh, Bash 互換シェルスクリプト、TDD

---

### Task 1: テスト用ヘルパーと Red フェーズのテスト作成

**Files:**
- Create: `tests/shell-function/test_codex_wrapper.sh`
- Modify: `zsh/.zshrc` (後で)

- [ ] **Step 1: Write the failing test**

```sh
#!/usr/bin/env zsh
set -euo pipefail

# テスト対象の関数を読み込む
source /Users/oki2a24/dotfiles/zsh/.zshrc

# ダミーの codex コマンドを記録用に作成
tmpdir=$(mktemp -d)
cat > $tmpdir/codex <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@"
EOF
chmod +x $tmpdir/codex
export PATH=$tmpdir:$PATH

# HERDR_ENV 未設定時のテスト
unset HERDR_ENV
result=$(codex arg1 arg2)
if [[ "$result" != "arg1 arg2" ]]; then
  echo "FAIL: unset HERDR_ENV expected 'arg1 arg2', got '$result'"
  exit 1
fi

# HERDR_ENV=1 時のテスト - ここで失敗するはず
export HERDR_ENV=1
result=$(codex arg1 arg2)
expected="--provider ollama arg1 arg2"
if [[ "$result" != "$expected" ]]; then
  echo "FAIL: HERDR_ENV=1 expected '$expected', got '$result'"
  exit 1
fi

echo "PASS"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `zsh tests/shell-function/test_codex_wrapper.sh`
Expected: FAIL with "`command not found`" or wrong args because functions not exist yet.

### Task 2: zsh/.zshrc に関数を最小実装 (Green)

**Files:**
- Modify: `zsh/.zshrc`

- [ ] **Step 1: Write minimal implementation**

```zsh
# シェル関数分離: codex/claude/pi with HERDR_ENV provider injection
__with_provider_if_herdr() {
  if [[ -n $HERDR_ENV && $HERDR_ENV == 1 ]]; then
    args=(--provider ollama "$@")
  else
    args=("$@")
  fi
  printf '%s\n' "${args[@]}"
}

codex() {
  if [[ -n $HERDR_ENV && $HERDR_ENV == 1 ]]; then
    command codex --provider ollama "$@"
  else
    command codex "$@"
  fi
}

claude() {
  if [[ -n $HERDR_ENV && $HERDR_ENV == 1 ]]; then
    command claude --provider ollama "$@"
  else
    command claude "$@"
  fi
}

pi() {
  if [[ -n $HERDR_ENV && $HERDR_ENV == 1 ]]; then
    command pi --provider ollama "$@"
  else
    command pi "$@"
  fi
}
```

- [ ] **Step 2: Run test to verify it passes**

Run: `zsh tests/shell-function/test_codex_wrapper.sh`
Expected: PASS

### Task 3: claude と pi のテスト追加と Red-Green

**Files:**
- Modify: `tests/shell-function/test_codex_wrapper.sh`

- [ ] **Step 1: Write the failing test for claude/pi**

```sh
# 追加テストケース
tmpdir=$(mktemp -d)
for cmd in claude pi; do
  cat > $tmpdir/$cmd <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@"
EOF
  chmod +x $tmpdir/$cmd
done
export PATH=$tmpdir:$PATH

unset HERDR_ENV
for cmd in codex claude pi; do
  result=$($cmd a b)
  if [[ "$result" != "a b" ]]; then
    echo "FAIL: $cmd unset expected 'a b', got '$result'"
    exit 1
  fi
done

export HERDR_ENV=1
for cmd in codex claude pi; do
  result=$($cmd a b)
  expected="--provider ollama a b"
  if [[ "$result" != "$expected" ]]; then
    echo "FAIL: $cmd HERDR_ENV=1 expected '$expected', got '$result'"
    exit 1
  fi
done

echo "PASS all commands"
```

- [ ] **Step 2: Run test to verify it passes**

Run: `zsh tests/shell-function/test_codex_wrapper.sh`
Expected: PASS all commands

### Task 4: エッジケースのテスト追加

**Files:**
- Modify: `tests/shell-function/test_codex_wrapper.sh`

- [ ] **Step 1: Write edge case tests**

```sh
# HERDR_ENV=0 のテスト
export HERDR_ENV=0
result=$(codex x)
if [[ "$result" != "x" ]]; then
  echo "FAIL: HERDR_ENV=0 should not inject, got '$result'"
  exit 1
fi

# HERDR_ENV 空文字のテスト
export HERDR_ENV=""
result=$(codex y)
if [[ "$result" != "y" ]]; then
  echo "FAIL: HERDR_ENV empty should not inject, got '$result'"
  exit 1
fi

# 引数なしのテスト
unset HERDR_ENV
result=$(codex)
if [[ -n "$result" ]]; then
  echo "FAIL: no args expected empty, got '$result'"
  exit 1
fi

echo "PASS edge cases"
```

- [ ] **Step 2: Run test to verify it passes**

Run: `zsh tests/shell-function/test_codex_wrapper.sh`
Expected: PASS edge cases

### Task 5: リファクタリングとヘルパー共通化

**Files:**
- Modify: `zsh/.zshrc`

- [ ] **Step 1: Refactor to use helper**

```zsh
__build_args_with_provider() {
  if [[ -n $HERDR_ENV && $HERDR_ENV == 1 ]]; then
    printf '%s ' --provider ollama "$@"
    echo
  else
    printf '%s\n' "$@"
  fi
}

codex() {
  if [[ -n $HERDR_ENV && $HERDR_ENV == 1 ]]; then
    command codex --provider ollama "$@"
  else
    command codex "$@"
  fi
}
```

より良い共通化:
```zsh
__run_with_provider_if_herdr() {
  local cmd=$1
  shift
  if [[ -n $HERDR_ENV && $HERDR_ENV == 1 ]]; then
    command "$cmd" --provider ollama "$@"
  else
    command "$cmd" "$@"
  fi
}

codex() { __run_with_provider_if_herdr codex "$@"; }
claude() { __run_with_provider_if_herdr claude "$@"; }
pi() { __run_with_provider_if_herdr pi "$@"; }
```

- [ ] **Step 2: Run tests to verify still pass**

Run: `zsh tests/shell-function/test_codex_wrapper.sh`
Expected: PASS all

### Task 6: コミット

**Files:**
- Modify: `zsh/.zshrc`
- Create: `tests/shell-function/test_codex_wrapper.sh`

- [ ] **Step 1: Commit**

```bash
git add zsh/.zshrc tests/shell-function/test_codex_wrapper.sh
git commit -m "feat: add shell function wrappers for codex/claude/pi with HERDR_ENV provider injection"
```
