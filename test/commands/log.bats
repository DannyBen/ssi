#!/usr/bin/env bats

setup() {
  export NO_COLOR=1
}

@test "log prints message in ssi format" {
  run ./ssi log info installed version "1.2.3"

  [ "$status" -eq 0 ]
  [ "$output" = "• info → installed version 1.2.3" ]
}
