source_download() {
  local url="${1:-}"
  local destination="${2:-}"
  local stderr_file temp_root rc error_message

  if [[ -z "$url" || -z "$destination" ]]; then
    fail "Missing URL or destination for download"
    return 1
  fi

  if [[ -n "${SSI_DRY_RUN:-}" ]]; then
    if [[ "$destination" == "-" ]]; then
      log debug "[DRY] Downloading: $url -> stdout"
    else
      log debug "[DRY] Downloading: $url -> $destination"
    fi
    return 0
  fi

  temp_root="${TMPDIR:-/tmp}"
  stderr_file="$(mktemp "${temp_root%/}/ssi.download.stderr.XXXXXX")" || {
    fail "Could not allocate temporary file"
    return 1
  }

  source__download_with_tool "$url" "$destination" "$stderr_file"
  rc=$?

  if [[ -s "$stderr_file" ]]; then
    error_message="$(<"$stderr_file")"
    error_message="${error_message%$'\n'}"
  else
    error_message=""
  fi
  rm -f "$stderr_file"

  if [[ "$rc" -eq 0 ]]; then
    return 0
  fi

  if [[ -n "$error_message" ]]; then
    fail "$error_message"
    return 1
  fi

  fail "Download failed: $url"
  return 1
}

source__download_with_tool() {
  local url="${1:-}"
  local destination="${2:-}"
  local stderr_file="${3:-}"

  if is_command curl; then
    if [[ "$destination" == "-" ]]; then
      curl -fsSL "$url" 2>"$stderr_file"
    else
      curl -fsSL "$url" -o "$destination" 2>"$stderr_file"
    fi
    return $?
  fi

  if is_command wget; then
    wget -qO "$destination" "$url" 2>"$stderr_file"
    return $?
  fi

  printf "%s\n" "No downloader available (need curl or wget)" > "$stderr_file"
  return 1
}
