#!/usr/bin/env bats

setup() {
  BASE="$BATS_TEST_DIRNAME/../../../src/lib/bootstrap"
  source "$BASE/update_prepare_installer.sh"
}

@test "bootstrap_update_prepare_installer replaces function body" {
  file="$(mktemp)"

  cat >"$file" <<'EOF'
#!/usr/bin/env bash
prepare_installer() {
  echo "old"
}
echo "keep"
EOF

  replacement=$(cat <<'EOF'
prepare_installer() {
  echo "new"
}
EOF
)

  run bootstrap_update_prepare_installer "$file" "$replacement"

  [ "$status" -eq 0 ]
  grep -Fq 'echo "new"' "$file"
  ! grep -Fq 'echo "old"' "$file"
  grep -Fq 'echo "keep"' "$file"
}

@test "bootstrap_update_prepare_installer returns 2 when missing" {
  file="$(mktemp)"

  cat >"$file" <<'EOF'
#!/usr/bin/env bash
echo "no function"
EOF

  replacement=$(cat <<'EOF'
prepare_installer() {
  echo "new"
}
EOF
)

  run bootstrap_update_prepare_installer "$file" "$replacement"

  [ "$status" -eq 2 ]
}
