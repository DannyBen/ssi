fetch_source_type() {
  local source="${1:--}"

  if [[ "$source" == "-" ]]; then
    printf "stdin"
    return 0
  elif [[ "$source" =~ ^https?:// ]]; then
    printf "url"
    return 0
  elif [[ -f "$source" ]]; then
    printf "file"
    return 0
  else
    fail "Invalid source: $source"
    return 1
  fi
}
