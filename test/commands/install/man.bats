#!/usr/bin/env bats

setup() {
  tmp_root="$(mktemp -d)"
  fakebin="$tmp_root/bin"
  mkdir -p "$fakebin"
  export HOME="$tmp_root/home"
  mkdir -p "$HOME"
  export PATH="$fakebin:$PATH"
  export NO_COLOR=1
  export SSI_USER_MAN_ROOT="$tmp_root/user-man"
  export SSI_SYSTEM_MAN_ROOT="/root/ssi-system-man"
  mkdir -p "$SSI_USER_MAN_ROOT"
  FIXTURES="$BATS_TEST_DIRNAME/../../fixtures"
}

teardown() {
  rm -rf "$tmp_root"
}

@test "install man installs from url into user man root" {
  cp "$FIXTURES/bin/curl" "$fakebin/curl"
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/curl" "$fakebin/sudo"

  run ./ssi install man "https://example.com/tool.1"

  [ "$status" -eq 0 ]
  [ "$output" = $'• info  → Installing man page: tool.1\n• info  → Man page installed: '"$SSI_USER_MAN_ROOT"'/man1/tool.1' ]
  [ -f "$SSI_USER_MAN_ROOT/man1/tool.1" ]
  [ "$(cat "$SSI_USER_MAN_ROOT/man1/tool.1")" = "downloaded:https://example.com/tool.1" ]
}

@test "install man installs from stdin when explicit name is provided" {
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/sudo"

  run ./ssi install man - --name stdin-tool <<< "from-stdin"

  [ "$status" -eq 0 ]
  [ "$output" = $'• info  → Installing man page: stdin-tool\n• info  → Man page installed: '"$SSI_USER_MAN_ROOT"'/man1/stdin-tool.1' ]
  [ -f "$SSI_USER_MAN_ROOT/man1/stdin-tool.1" ]
  [ "$(cat "$SSI_USER_MAN_ROOT/man1/stdin-tool.1")" = "from-stdin" ]
}

@test "install man fails when target name cannot be determined and no explicit name provided" {
  cp "$FIXTURES/bin/curl" "$fakebin/curl"
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/curl" "$fakebin/sudo"

  run ./ssi install man "https://example.com/tools/"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Could not determine target name; use --name"* ]]
}

@test "install man installs all matching man pages from a directory" {
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/sudo"

  doc_root="$tmp_root/docs"
  mkdir -p "$doc_root/share/man/man1" "$doc_root/share/man/man5"
  printf "add" > "$doc_root/share/man/man1/rush-add.1"
  printf "list" > "$doc_root/share/man/man5/rush-list.5"
  printf "main" > "$doc_root/share/man/man1/rush.1"
  printf "ignore" > "$doc_root/share/man/man1/rush.md"

  run ./ssi install man "$doc_root"

  [ "$status" -eq 0 ]
  [[ "$output" == *"• info  → Man page installed: $SSI_USER_MAN_ROOT/man1/rush-add.1"* ]]
  [[ "$output" == *"• info  → Man page installed: $SSI_USER_MAN_ROOT/man5/rush-list.5"* ]]
  [[ "$output" == *"• info  → Man page installed: $SSI_USER_MAN_ROOT/man1/rush.1"* ]]
  [ -f "$SSI_USER_MAN_ROOT/man1/rush-add.1" ]
  [ -f "$SSI_USER_MAN_ROOT/man5/rush-list.5" ]
  [ -f "$SSI_USER_MAN_ROOT/man1/rush.1" ]
  [ ! -e "$SSI_USER_MAN_ROOT/man1/rush.md" ]
  [ "$(cat "$SSI_USER_MAN_ROOT/man1/rush-add.1")" = "add" ]
  [ "$(cat "$SSI_USER_MAN_ROOT/man5/rush-list.5")" = "list" ]
  [ "$(cat "$SSI_USER_MAN_ROOT/man1/rush.1")" = "main" ]
}

@test "install man installs all matching man pages from a local archive" {
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/sudo"

  doc_root="$tmp_root/archive-src"
  archive_path="$tmp_root/docs.tgz"
  mkdir -p "$doc_root/share/man/man1" "$doc_root/share/man/man5"
  printf "add" > "$doc_root/share/man/man1/rush-add.1"
  printf "list" > "$doc_root/share/man/man5/rush-list.5"
  printf "ignore" > "$doc_root/share/man/man5/rush.txt"
  tar -czf "$archive_path" -C "$doc_root" .

  run ./ssi install man "$archive_path"

  [ "$status" -eq 0 ]
  [[ "$output" == *"• info  → Installing man pages: docs.tgz"* ]]
  [[ "$output" == *"• info  → Man page installed: $SSI_USER_MAN_ROOT/man1/rush-add.1"* ]]
  [[ "$output" == *"• info  → Man page installed: $SSI_USER_MAN_ROOT/man5/rush-list.5"* ]]
  [ -f "$SSI_USER_MAN_ROOT/man1/rush-add.1" ]
  [ -f "$SSI_USER_MAN_ROOT/man5/rush-list.5" ]
  [ ! -e "$SSI_USER_MAN_ROOT/man5/rush.txt" ]
}

@test "install man installs all matching man pages from a url archive" {
  cp "$FIXTURES/bin/curl_archive" "$fakebin/curl"
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/curl" "$fakebin/sudo"

  doc_root="$tmp_root/archive-src"
  archive_path="$tmp_root/docs.tgz"
  mkdir -p "$doc_root/share/man/man1" "$doc_root/share/man/man8"
  printf "main" > "$doc_root/share/man/man1/rush.1"
  printf "admin" > "$doc_root/share/man/man8/rush-admin.8"
  tar -czf "$archive_path" -C "$doc_root" .
  export ARCHIVE_PAYLOAD="$archive_path"

  run ./ssi install man "https://example.com/docs.tgz"

  [ "$status" -eq 0 ]
  [[ "$output" == *"• info  → Installing man pages: docs.tgz"* ]]
  [[ "$output" == *"• info  → Man page installed: $SSI_USER_MAN_ROOT/man1/rush.1"* ]]
  [[ "$output" == *"• info  → Man page installed: $SSI_USER_MAN_ROOT/man8/rush-admin.8"* ]]
  [ "$(cat "$SSI_USER_MAN_ROOT/man1/rush.1")" = "main" ]
  [ "$(cat "$SSI_USER_MAN_ROOT/man8/rush-admin.8")" = "admin" ]

  unset -v ARCHIVE_PAYLOAD
}

@test "install man is a no-op in dry run mode" {
  export SSI_DRY_RUN=1
  cp "$FIXTURES/bin/sudo" "$fakebin/sudo"
  chmod +x "$fakebin/sudo"

  run ./ssi install man "https://example.com/tool.1"

  [ "$status" -eq 0 ]
  [ "$output" = $'• warn  → Dry-run enabled\n• info  → Installing man page: tool.1\n• info  → Man page installed: '"$SSI_USER_MAN_ROOT"'/man1/tool.1' ]
  [ ! -e "$SSI_USER_MAN_ROOT/man1/tool.1" ]

  unset -v SSI_DRY_RUN
}
