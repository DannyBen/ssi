#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/core/env/is_command.sh"
  source "$BASE/completion/_bash_root.sh"
  source "$BASE/completion/mode.sh"
  source "$BASE/completion/path.sh"
  source "$BASE/completion/paths.sh"
}

@test "completion_paths returns system then user paths" {
  export SSI_SYSTEM_BASH_COMPLETION_ROOT="/system/bash"
  export SSI_USER_BASH_COMPLETION_ROOT="/user/bash"

  run completion_paths bash

  [ "$status" -eq 0 ]
  [ "$output" = $'/system/bash\n/user/bash' ]
}
