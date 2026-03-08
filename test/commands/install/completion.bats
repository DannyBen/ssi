#!/usr/bin/env bats

setup() {
  tmp_root="$(mktemp -d)"
  fakebin="$tmp_root/bin"
  mkdir -p "$fakebin"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"
  export PATH="$fakebin:$PATH"
  export NO_COLOR=1
  export SSI_USER_BASH_COMPLETION_ROOT="$tmp_root/user-bash-completions"
  export SSI_SYSTEM_BASH_COMPLETION_ROOT="/root/ssi-system-completions"
  export SSI_USER_ZSH_COMPLETION_ROOT="$tmp_root/user-zsh-completions"
  export SSI_SYSTEM_ZSH_COMPLETION_ROOT="/root/ssi-system-zsh-completions"
  mkdir -p "$SSI_USER_BASH_COMPLETION_ROOT"
  mkdir -p "$SSI_USER_ZSH_COMPLETION_ROOT"
  FIXTURES="$BATS_TEST_DIRNAME/../../fixtures"
}

teardown() {
  rm -rf "$tmp_root"
}

@test "install completion installs from url into user completion root" {
  cp "$FIXTURES/bin/curl" "$fakebin/curl"
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/curl" "$fakebin/sudo"

  run ./ssi install completion "https://example.com/tool"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Installed: $SSI_USER_BASH_COMPLETION_ROOT/tool" ]
  [ -f "$SSI_USER_BASH_COMPLETION_ROOT/tool" ]
  [ "$(cat "$SSI_USER_BASH_COMPLETION_ROOT/tool")" = "downloaded:https://example.com/tool" ]
}

@test "install completion installs from stdin when explicit name is provided" {
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/sudo"

  run ./ssi install completion - --name stdin-tool <<< "from-stdin"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Installed: $SSI_USER_BASH_COMPLETION_ROOT/stdin-tool" ]
  [ -f "$SSI_USER_BASH_COMPLETION_ROOT/stdin-tool" ]
  [ "$(cat "$SSI_USER_BASH_COMPLETION_ROOT/stdin-tool")" = "from-stdin" ]
}

@test "install completion installs to zsh root when --shell zsh is provided" {
  cp "$FIXTURES/bin/curl" "$fakebin/curl"
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/curl" "$fakebin/sudo"

  run ./ssi install completion "https://example.com/_tool" --shell zsh

  [ "$status" -eq 0 ]
  [ "$output" = "• info → Installed: $SSI_USER_ZSH_COMPLETION_ROOT/_tool" ]
  [ -f "$SSI_USER_ZSH_COMPLETION_ROOT/_tool" ]
  [ "$(cat "$SSI_USER_ZSH_COMPLETION_ROOT/_tool")" = "downloaded:https://example.com/_tool" ]
}

@test "install completion fails when target name cannot be determined and no explicit name provided" {
  cp "$FIXTURES/bin/curl" "$fakebin/curl"
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/curl" "$fakebin/sudo"

  run ./ssi install completion "https://example.com/tools/"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Could not determine target name; use --name"* ]]
}

@test "install completion is a no-op in dry run mode" {
  export SSI_DRY_RUN=1
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/sudo"

  run ./ssi install completion "https://example.com/tool"

  [ "$status" -eq 0 ]
  [ "$output" = $'• warn → Dry-run enabled\n• info → Installed: '"$SSI_USER_BASH_COMPLETION_ROOT"'/tool' ]
  [ ! -e "$SSI_USER_BASH_COMPLETION_ROOT/tool" ]

  unset -v SSI_DRY_RUN
}
