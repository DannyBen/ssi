url="${args[url]}"
target="${args[--output]:-}"

if [[ -z "$target" ]]; then
  target="$(source_target_name "$url")" || return 1
  if [[ -z "$target" ]]; then
    fail "Could not determine output file name; use -o FILE or -o -"
    return 1
  fi
fi

if [[ "$target" != "-" ]]; then
  dry_run_note
  log info "$(bold "Downloading file"): $target"
fi

source_download "$url" "$target" || return 1

if [[ "$target" != "-" ]]; then
  log info "File downloaded: $target"
fi
