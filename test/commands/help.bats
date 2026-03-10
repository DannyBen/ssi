#!/usr/bin/env bats

setup() {
  export NO_COLOR=1
}

@test "top-level help exits successfully" {
  run ./ssi --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"Simple Script Installer"* ]]
}

@test "top-level help still calls color helpers when NO_COLOR is set" {
  run env NO_COLOR=1 bash -x ./ssi --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"++ bold Usage:"* ]]
  [[ "$output" == *"++ green install"* ]]
  [[ "$output" == *"++ print_in_color"* ]]
}
