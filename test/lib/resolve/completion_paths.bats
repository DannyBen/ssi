#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/is_command.sh"
  source "$BASE/resolve/bash_completion_root.sh"
  source "$BASE/resolve/completion_mode.sh"
  source "$BASE/resolve/completion_base_path.sh"
  source "$BASE/resolve/completion_paths.sh"
}

@test "resolve_completion_paths returns system then user paths" {
  export SSI_SYSTEM_BASH_COMPLETION_ROOT="/system/bash"
  export SSI_USER_BASH_COMPLETION_ROOT="/user/bash"

  run resolve_completion_paths bash

  [ "$status" -eq 0 ]
  [ "$output" = $'/system/bash\n/user/bash' ]
}
