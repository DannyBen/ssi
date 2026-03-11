#!/usr/bin/env bats

setup() {
  tmp_root="$(mktemp -d)"
  fakebin="$tmp_root/bin"
  mkdir -p "$fakebin"
  export HOME="$tmp_root/home"
  export PATH="$fakebin:$PATH"
  export NO_COLOR=1
  export SSI_USER_MAN_ROOT="$tmp_root/user-man"
  export SSI_SYSTEM_MAN_ROOT="$tmp_root/system-man"
  mkdir -p "$SSI_USER_MAN_ROOT" "$SSI_SYSTEM_MAN_ROOT"
}

teardown() {
  rm -rf "$tmp_root"
}

@test "uninstall man removes user man page when present" {
  file="$SSI_USER_MAN_ROOT/man1/tool.1"
  mkdir -p "$(dirname "$file")"
  printf "page" > "$file"

  run ./ssi uninstall man tool

  [ "$status" -eq 0 ]
  [ "$output" = $'• info  → Uninstalling man page: tool\n• info  → Man page removed: '"$file" ]
  [ ! -e "$file" ]
}

@test "uninstall man removes system man page when present" {
  file="$SSI_SYSTEM_MAN_ROOT/man5/tool.5"
  mkdir -p "$(dirname "$file")"
  printf "page" > "$file"

  run ./ssi uninstall man tool.5

  [ "$status" -eq 0 ]
  [ "$output" = $'• info  → Uninstalling man page: tool.5\n• info  → Man page removed: '"$file" ]
  [ ! -e "$file" ]
}

@test "uninstall man reports not found when missing" {
  run ./ssi uninstall man missing-tool

  [ "$status" -eq 0 ]
  [ "$output" = $'• info  → Uninstalling man page: missing-tool\n• warn  → Man page missing: missing-tool' ]
}

@test "uninstall man without extension removes base and subcommand pages across sections" {
  user_main="$SSI_USER_MAN_ROOT/man1/rush.1"
  user_sub="$SSI_USER_MAN_ROOT/man5/rush-add.5"
  system_sub="$SSI_SYSTEM_MAN_ROOT/man1/rush-add.1"
  system_other="$SSI_SYSTEM_MAN_ROOT/man1/rushx.1"
  user_other="$SSI_USER_MAN_ROOT/man1/rusher.1"

  mkdir -p "$(dirname "$user_main")" "$(dirname "$user_sub")" \
    "$(dirname "$system_sub")" "$(dirname "$system_other")"
  printf "page" > "$user_main"
  printf "page" > "$user_sub"
  printf "page" > "$system_sub"
  printf "page" > "$system_other"
  printf "page" > "$user_other"

  run ./ssi uninstall man rush

  [ "$status" -eq 0 ]
  [[ "$output" == *"• info  → Uninstalling man page: rush"* ]]
  [[ "$output" == *"• info  → Man page removed: $system_sub"* ]]
  [[ "$output" == *"• info  → Man page removed: $user_main"* ]]
  [[ "$output" == *"• info  → Man page removed: $user_sub"* ]]
  [ ! -e "$user_main" ]
  [ ! -e "$user_sub" ]
  [ ! -e "$system_sub" ]
  [ -e "$system_other" ]
  [ -e "$user_other" ]
}
