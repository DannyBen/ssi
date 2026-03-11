bin_uninstall() {
  local name="${1:-}"
  local target_root target_path removed

  removed=0
  while IFS= read -r target_root; do
    [[ -n "$target_root" ]] || continue
    target_path="${target_root}/${name}"
    if [[ -f "$target_path" ]]; then
      remove_file "$target_path" || return 1
      log info "Executable removed: $target_path"
      removed=1
    fi
  done < <(bin_roots)

  if [[ "$removed" -eq 0 ]]; then
    log warn "Executable missing: $name"
  fi
}
