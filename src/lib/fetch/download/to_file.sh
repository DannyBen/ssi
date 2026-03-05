fetch_download_to_file() {
  local url="${1:-}"
  local destination="${2:-}"

  if [[ -z "$url" || -z "$destination" ]]; then
    fail "Missing URL or destination for download"
    return 1
  fi

  if is_command curl; then
    curl -fsSL "$url" -o "$destination" && return 0
    fail "Failed downloading with curl: $url"
    return 1
  fi

  if is_command wget; then
    wget -qO "$destination" "$url" && return 0
    fail "Failed downloading with wget: $url"
    return 1
  fi

  fail "No downloader available (need curl or wget)"
  return 1
}
