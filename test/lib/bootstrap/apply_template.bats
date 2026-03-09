#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib"
  source "$BASE/core/ui/colors.sh"
  source "$BASE/core/ui/log.sh"
  source "$BASE/bootstrap/update_prepare_installer.sh"
  source "$BASE/bootstrap/apply_template.sh"
  export NO_COLOR=1
}

@test "bootstrap_apply_template writes new file" {
  file="$(mktemp)"
  rm -f "$file"

  template="#!/usr/bin/env bash
echo ok"
  prepare_section="prepare_installer() { echo ok; }"

  run bootstrap_apply_template "$file" "$template" "$prepare_section"

  [ "$status" -eq 0 ]
  grep -Fq "Created bootstrap template" <<<"$output"
  grep -Fq "echo ok" "$file"
}

@test "bootstrap_apply_template updates existing file" {
  file="$(mktemp)"

  cat >"$file" <<'EOF'
#!/usr/bin/env bash
prepare_installer() {
  echo "old"
}
EOF

  template="#!/usr/bin/env bash
echo ok"
  prepare_section=$(cat <<'EOF'
prepare_installer() {
  echo "new"
}
EOF
)

  run bootstrap_apply_template "$file" "$template" "$prepare_section"

  [ "$status" -eq 0 ]
  grep -Fq "Updated prepare_installer" <<<"$output"
  grep -Fq 'echo "new"' "$file"
}

@test "bootstrap_apply_template errors when function missing" {
  file="$(mktemp)"

  cat >"$file" <<'EOF'
#!/usr/bin/env bash
echo "no function"
EOF

  template="#!/usr/bin/env bash
echo ok"
  prepare_section="prepare_installer() { echo new; }"

  run bootstrap_apply_template "$file" "$template" "$prepare_section"

  [ "$status" -eq 1 ]
  grep -Fq "prepare_installer not found" <<<"$output"
}
