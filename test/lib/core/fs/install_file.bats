#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../../src/lib"
  source "$BASE/core/ui/colors.sh"
  source "$BASE/core/ui/log.sh"
  source "$BASE/core/env/is_sudo_usable.sh"
  source "$BASE/core/fs/create_dir.sh"
  source "$BASE/core/fs/install_file.sh"
}

install_and_cat() {
  local src="$1"
  local dest="$2"
  local mode="${3:-755}"
  install_file "$src" "$dest" "$mode" || return 1
  cat "$dest"
}

@test "install_file installs to writable destination" {
  is_sudo_usable() { return 1; }

  src="$(mktemp)"
  dest_dir="$(mktemp -d)"
  dest="$dest_dir/rush"
  printf "abc" > "$src"

  run install_and_cat "$src" "$dest" 755

  [ "$status" -eq 0 ]
  [ "$output" = "abc" ]
}

@test "install_file creates destination directory when writable" {
  is_sudo_usable() { return 1; }

  src="$(mktemp)"
  root="$(mktemp -d)"
  dest="$root/deep/bin/rush"
  printf "abc" > "$src"

  run install_file "$src" "$dest" 755

  [ "$status" -eq 0 ]
  [ -f "$dest" ]
}

@test "install_file is a no-op in dry run mode" {
  export SSI_DRY_RUN=1
  export SSI_LOG_LEVEL=debug

  src="$(mktemp)"
  root="$(mktemp -d)"
  dest="$root/deep/bin/rush"
  printf "abc" > "$src"

  run install_file "$src" "$dest" 755

  [ "$status" -eq 0 ]
  [ ! -e "$dest" ]
  [ ! -d "$root/deep/bin" ]
  [[ "$output" == *"[DRY] Installing file: $src -> $dest (mode 755)"* ]]

  unset -v SSI_DRY_RUN SSI_LOG_LEVEL
}

@test "install_file fails when destination is not writable and sudo unavailable" {
  is_sudo_usable() { return 1; }
  install() { return 1; }
  mkdir() { return 1; }

  src="$(mktemp)"
  printf "abc" > "$src"
  dest="$(mktemp -d)/rush"

  run install_file "$src" "$dest" 755

  [ "$status" -eq 1 ]
  [ -n "$output" ]
}

@test "install_file uses sudo install when destination is not writable and sudo is available" {
  is_sudo_usable() { return 0; }
  install() { return 1; }
  sudo() {
    if [[ "$1" == "mkdir" ]]; then
      mkdir -p "${@:3}"
    elif [[ "$1" == "install" ]]; then
      command install "${@:2}"
    else
      return 1
    fi
  }

  src="$(mktemp)"
  root="$(mktemp -d)"
  dest="$root/out/rush"
  printf "abc" > "$src"

  run install_file "$src" "$dest" 755

  [ "$status" -eq 0 ]
  [ -f "$dest" ]
  unset -f sudo
}
