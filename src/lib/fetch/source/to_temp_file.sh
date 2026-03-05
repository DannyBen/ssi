fetch_source_to_temp_file() {
  local source="${1:--}"
  local temp_root="${2:-${TMPDIR:-/tmp}}"
  local source_type temp_file

  source_type="$(fetch_source_type "$source")" || return 1

  temp_file="$(mktemp "${temp_root%/}/ssi.fetch.XXXXXX")" || {
    fail "Could not allocate temporary file"
    return 1
  }

  case "$source_type" in
    stdin)
      cat > "$temp_file" || {
        fail "Could not read source from stdin"
        return 1
      }
      ;;
    file)
      cp "$source" "$temp_file" || {
        fail "Could not copy source file"
        return 1
      }
      ;;
    url)
      fetch_download_to_file "$source" "$temp_file" || return 1
      ;;
  esac

  printf "%s" "$temp_file"
}
