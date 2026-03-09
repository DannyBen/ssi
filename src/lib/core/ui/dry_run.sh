dry_run_note() {
  if [[ -n "${SSI_DRY_RUN:-}" && -z "${_SSI_DRY_RUN_NOTED:-}" ]]; then
    log warn "Dry-run enabled"
    export _SSI_DRY_RUN_NOTED=1
  fi
}
