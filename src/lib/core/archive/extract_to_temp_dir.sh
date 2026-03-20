archive_extract_to_temp_dir() {
  local source_input="${1:-}"
  local temp_root="${2:-${TMPDIR:-/tmp}}"
  local archive_kind source_kind archive_file archive_dir stderr_file
  local cleanup_archive_file=0 rc error_message message

  archive_kind="$(archive_type "$source_input")" || return 1
  source_kind="$(source_type "$source_input")" || return 1

  if ! is_command tar; then
    fail "No archive extractor available (need tar)"
    return 1
  fi

  if [[ -n "${SSI_DRY_RUN:-}" && "$source_kind" == "url" ]]; then
    log debug "[DRY] Extracting archive: $source_input -> /dev/null"
    printf "%s" "/dev/null"
    return 0
  fi

  if [[ "$source_kind" == "file" ]]; then
    archive_file="$source_input"
  else
    archive_file="$(source_to_temp_file "$source_input" "$temp_root")" || return 1
    cleanup_archive_file=1
  fi

  archive_dir="$(mktemp -d "${temp_root%/}/ssi.archive.XXXXXX")" || {
    fail "Could not allocate temporary directory"
    return 1
  }

  stderr_file="$(mktemp "${temp_root%/}/ssi.archive.stderr.XXXXXX")" || {
    remove_dir "$archive_dir" || return 1
    fail "Could not allocate temporary file"
    return 1
  }

  case "$archive_kind" in
    tar.gz)
      message="Extracting archive: $archive_file -> $archive_dir"
      log debug "$message"
      tar -xzf "$archive_file" -C "$archive_dir" 2>"$stderr_file"
      rc=$?
      ;;
    *)
      printf "%s\n" "Unsupported archive format: $source_input" > "$stderr_file"
      rc=1
      ;;
  esac

  if [[ "$cleanup_archive_file" -eq 1 && "$archive_file" != "/dev/null" ]]; then
    remove_file "$archive_file" || {
      rm -f "$stderr_file"
      remove_dir "$archive_dir" || return 1
      return 1
    }
  fi

  if [[ "$rc" -ne 0 ]]; then
    if [[ -s "$stderr_file" ]]; then
      error_message="$(<"$stderr_file")"
      error_message="${error_message%$'\n'}"
    else
      error_message="Could not extract archive: $source_input"
    fi
    rm -f "$stderr_file"
    remove_dir "$archive_dir" || return 1
    fail "$error_message"
    return 1
  fi

  rm -f "$stderr_file"
  printf "%s" "$archive_dir"
}
