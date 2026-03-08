#!/usr/bin/env bats

setup() {
  tmp_root="$(mktemp -d)"
  fakebin="$tmp_root/bin"
  mkdir -p "$fakebin"
  export HOME="$tmp_root/home"
  export PATH="$fakebin:$PATH"
  export NO_COLOR=1
  export SSI_USER_BASH_COMPLETION_ROOT="$tmp_root/user-bash-completions"
  export SSI_SYSTEM_BASH_COMPLETION_ROOT="$tmp_root/system-bash-completions"
  export SSI_USER_ZSH_COMPLETION_ROOT="$tmp_root/user-zsh-completions"
  export SSI_SYSTEM_ZSH_COMPLETION_ROOT="$tmp_root/system-zsh-completions"
  mkdir -p "$SSI_USER_BASH_COMPLETION_ROOT" "$SSI_SYSTEM_BASH_COMPLETION_ROOT"
  mkdir -p "$SSI_USER_ZSH_COMPLETION_ROOT" "$SSI_SYSTEM_ZSH_COMPLETION_ROOT"
}

teardown() {
  rm -rf "$tmp_root"
}

@test "uninstall completion removes user completion when present" {
  file="$SSI_USER_BASH_COMPLETION_ROOT/tool"
  printf "script" > "$file"

  run ./ssi uninstall completion tool

  [ "$status" -eq 0 ]
  [ "$output" = "• info  → Removed: $file" ]
  [ ! -e "$file" ]
}

@test "uninstall completion removes system completion when present" {
  file="$SSI_SYSTEM_BASH_COMPLETION_ROOT/system-tool"
  printf "script" > "$file"

  run ./ssi uninstall completion system-tool

  [ "$status" -eq 0 ]
  [ "$output" = "• info  → Removed: $file" ]
  [ ! -e "$file" ]
}

@test "uninstall completion reports not found when missing" {
  run ./ssi uninstall completion missing-tool

  [ "$status" -eq 0 ]
  [ "$output" = "• warn  → Not found: missing-tool" ]
}

@test "uninstall completion removes zsh completion when present" {
  file="$SSI_USER_ZSH_COMPLETION_ROOT/_tool"
  printf "script" > "$file"

  run ./ssi uninstall completion _tool --shell zsh

  [ "$status" -eq 0 ]
  [ "$output" = "• info  → Removed: $file" ]
  [ ! -e "$file" ]
}
