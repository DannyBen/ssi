#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib/bootstrap"
  source "$BASE/prepare_installer.sh"
}

@test "bootstrap_prepare_installer renders versioned function" {
  run bootstrap_prepare_installer "1.2.3"

  [ "$status" -eq 0 ]
  echo "$output" | grep -Fq "prepare_installer() {"
  echo "$output" | grep -Fq 'SSI_VERSION="1.2.3"'
  echo "$output" | grep -Fq 'releases/download/v$SSI_VERSION/ssi'
}
