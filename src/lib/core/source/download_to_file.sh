source_download_to_file() {
  local url="${1:-}"
  local destination="${2:-}"

  if [[ -z "$url" || -z "$destination" ]]; then
    fail "Missing URL or destination for download"
    return 1
  fi

  source_download "$url" "$destination"
}
