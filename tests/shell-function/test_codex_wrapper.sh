#!/usr/bin/env zsh
set -eu

# テスト対象の関数を読み込む
source /Users/oki2a24/dotfiles/zsh/.zshrc

# ダミーの codex コマンドを記録用に作成
tmpdir=$(mktemp -d)
cat > $tmpdir/codex <<'EOF'
#!/usr/bin/env bash
printf '%s ' "$@"
echo
EOF
chmod +x $tmpdir/codex
export PATH=$tmpdir:$PATH

# HERDR_ENV 未設定時のテスト
unset HERDR_ENV
result=$(codex arg1 arg2 | xargs)
if [[ "$result" != "arg1 arg2" ]]; then
  echo "FAIL: unset HERDR_ENV expected 'arg1 arg2', got '$result'"
  exit 1
fi

# HERDR_ENV=1 時のテスト - ここで失敗するはず
export HERDR_ENV=1
result=$(codex arg1 arg2 | xargs)
expected="--local-provider ollama arg1 arg2"
if [[ "$result" != "$expected" ]]; then
  echo "FAIL: HERDR_ENV=1 expected '$expected', got '$result'"
  exit 1
fi

# 追加テストケース - claude と pi
tmpdir=$(mktemp -d)
for cmd in claude pi; do
  cat > $tmpdir/$cmd <<'EOF'
#!/usr/bin/env bash
printf '%s ' "$@"
echo
EOF
  chmod +x $tmpdir/$cmd
done
export PATH=$tmpdir:$PATH

unset HERDR_ENV
for cmd in codex claude pi; do
  result=$($cmd a b | xargs)
  if [[ "$result" != "a b" ]]; then
    echo "FAIL: $cmd unset expected 'a b', got '$result'"
    exit 1
  fi
done

export HERDR_ENV=1
for cmd in codex claude pi; do
  result=$($cmd a b | xargs)
  case $cmd in
    codex) expected="--local-provider ollama a b" ;;
    pi)    expected="--provider ollama a b" ;;
    *)     expected="a b" ;;
  esac
  if [[ "$result" != "$expected" ]]; then
    echo "FAIL: $cmd HERDR_ENV=1 expected '$expected', got '$result'"
    exit 1
  fi
done

echo "PASS all commands"

# HERDR_ENV=0 のテスト
export HERDR_ENV=0
result=$(codex x | xargs)
if [[ "$result" != "x" ]]; then
  echo "FAIL: HERDR_ENV=0 should not inject, got '$result'"
  exit 1
fi

# HERDR_ENV 空文字のテスト
export HERDR_ENV=""
result=$(codex y | xargs)
if [[ "$result" != "y" ]]; then
  echo "FAIL: HERDR_ENV empty should not inject, got '$result'"
  exit 1
fi

# 引数なしのテスト
unset HERDR_ENV
result=$(codex | xargs)
if [[ -n "$result" ]]; then
  echo "FAIL: no args expected empty, got '$result'"
  exit 1
fi

echo "PASS edge cases"
