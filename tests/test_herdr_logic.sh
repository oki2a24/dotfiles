#!/bin/zsh

# setup environment for test
setup() {
  # Create a temporary zshrc with the functions from dotfiles
  sed -n '/^__herdr_pane_exists/,/^}/p; /^__run_with_provider_if_herdr/,/^}/p' /Users/oki2a24/dotfiles/zsh/.zshrc > /tmp/test_zshrc.zsh
}

teardown() {
  rm -f /tmp/test_zshrc.zsh
}

run_expected_behavior_test() {
  setup
  echo "Test: Passing an explicit pane ID to __run_with_provider_if_herdr (Expected behavior)"
  echo "Even if HERDR_PANE_ID is wrong, providing the correct target should trigger provider flags."

  # Setup mismatching environment variable
  export HERDR_PANE_ID="w7:p1" 
  
  # We'll test a subshell where we re-define command to capture arguments.
  # Our goal is for __run_with_provider_if_herdr to accept an optional 4th argument (target pane ID).
  local result=$(zsh -c '
    source /tmp/test_zshrc.zsl
    herdr() { echo "{\"result\": {\"agents\": [{\"pane_id\": \"w7:pG\"}]}}"; }
    command() { echo "$*"; }
    # Currently this fails because it only handles cmd, flag, val and then shift 3.
    # It ignores additional arguments after the command's own args? 
    # No, looking at .zshrc:
    # 37: local cmd=$1 provider_flag=$2 provider_val=$3
    # 38: shift 3
    # The remaining args are $@. So it doesn't allow passing a target pane ID AFTER the command.
    
    # Let us assume the fix will be to support an optional 4th arg as the "target" for occurrence check.
    # But standard pattern is: cmd flag val [target] --args... 
    # Or simpler: shift the args differently.

    __run_with_provider_if_herdr test_cmd --local-provider ollama w7:pG arg1
  ')

  teardown
  echo "Command executed with args: $result"

  # In a SUCCESSFUL (Green) implementation, the command should include "--local-provider" 
  # because we explicitly told it to check for w7:pG.
  if [[ "$result" == *"--local-provider"* ]]; then
    echo "✅ PASS: The command included provider flags using the explicit pane ID."
    exit 0
  else
    echo "❌ FAIL (RED phase): Command missed flags even with explicit correct pane ID provided. This is what we want to fix."
    exit 1
  fi
}

run_expected_behavior_test
