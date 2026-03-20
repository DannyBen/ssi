#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../../src/lib"
  source "$BASE/core/ui/colors.sh"
  source "$BASE/core/ui/log.sh"
  source "$BASE/core/env/is_command.sh"
  source "$BASE/core/source/target_name.sh"
  source "$BASE/core/source/source_type.sh"
  source "$BASE/core/source/source_to_temp_file.sh"
  source "$BASE/core/fs/remove_file.sh"
  source "$BASE/core/archive/type.sh"
  source "$BASE/core/archive/extract_to_temp_dir.sh"
  export NO_COLOR=1
}

teardown() {
  unset -v NO_COLOR log_level
}

@test "archive_extract_to_temp_dir extracts local tar.gz archive" {
  tmp_root="$(mktemp -d)"
  mkdir -p "$tmp_root/src/share/man/man1"
  printf "main" > "$tmp_root/src/share/man/man1/tool.1"
  tar -czf "$tmp_root/tool.tgz" -C "$tmp_root/src" .

  run archive_extract_to_temp_dir "$tmp_root/tool.tgz"

  [ "$status" -eq 0 ]
  [ -f "$output/share/man/man1/tool.1" ]

  rm -rf "$tmp_root" "$output"
}

@test "archive_extract_to_temp_dir extracts url archive through source_to_temp_file" {
  tmp_root="$(mktemp -d)"
  mkdir -p "$tmp_root/src/share/man/man1"
  printf "main" > "$tmp_root/src/share/man/man1/tool.1"
  tar -czf "$tmp_root/tool.tgz" -C "$tmp_root/src" .
  source_to_temp_file() {
    printf "%s" "$tmp_root/tool.tgz"
  }
  remove_file() { return 0; }

  run archive_extract_to_temp_dir "https://example.com/tool.tgz"

  [ "$status" -eq 0 ]
  [ -f "$output/share/man/man1/tool.1" ]

  rm -rf "$tmp_root" "$output"
}

@test "archive_extract_to_temp_dir returns /dev/null for url archive in dry run mode" {
  export SSI_DRY_RUN=1

  run archive_extract_to_temp_dir "https://example.com/tool.tgz"

  [ "$status" -eq 0 ]
  [ "$output" = "/dev/null" ]

  unset -v SSI_DRY_RUN
}

@test "archive_extract_to_temp_dir fails when tar is unavailable" {
  tmp_root="$(mktemp -d)"
  mkdir -p "$tmp_root/src"
  printf "main" > "$tmp_root/src/tool.1"
  tar -czf "$tmp_root/tool.tgz" -C "$tmp_root/src" .
  is_command() {
    [[ "$1" != "tar" ]]
  }

  run archive_extract_to_temp_dir "$tmp_root/tool.tgz"

  rm -rf "$tmp_root"

  [ "$status" -eq 1 ]
  [[ "$output" == *"No archive extractor available"* ]]
}

@test "archive_extract_to_temp_dir logs extract action in debug mode" {
  tmp_root="$(mktemp -d)"
  log_level=debug
  mkdir -p "$tmp_root/src/share/man/man1"
  printf "main" > "$tmp_root/src/share/man/man1/tool.1"
  tar -czf "$tmp_root/tool.tgz" -C "$tmp_root/src" .

  run archive_extract_to_temp_dir "$tmp_root/tool.tgz"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Extracting archive: $tmp_root/tool.tgz -> "* ]]
  [[ "$output" == *" -> /tmp/ssi.archive."* ]]

  rm -rf "$tmp_root" "${output##*$'\n'}"
}
