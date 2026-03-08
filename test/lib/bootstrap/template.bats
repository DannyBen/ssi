#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib/bootstrap"
  source "$BASE/template.sh"
}

@test "bootstrap_template injects prepare section and example" {
  prepare_section=$(cat <<'EOF'
prepare_installer() {
  echo "hello"
}
EOF
)

  run bootstrap_template "$prepare_section"

  [ "$status" -eq 0 ]
  echo "$output" | grep -Fq "#!/usr/bin/env bash"
  echo "$output" | grep -Fq "prepare_installer() {"
  echo "$output" | grep -Fq 'echo "hello"'
  echo "$output" | grep -Fq "Example installation steps"
}
