bootstrap_template() {
  local prepare_section="$1"
  local template

  template=$(cat <<'BOOTSTRAP'
#!/usr/bin/env bash
set -euo pipefail

@PREPARE@

# Example installation steps:
# prepare_installer
# ssi log info "Installing <tool>"
# ssi install bin <url>
# ssi install man <url>
# ssi log info "<tool> --version : $(<tool> --version)"
BOOTSTRAP
)

  printf "%s\n" "${template//@PREPARE@/$prepare_section}"
}
