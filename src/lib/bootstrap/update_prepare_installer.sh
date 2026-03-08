bootstrap_update_prepare_installer() {
  local file="$1"
  local replacement="$2"
  local tmp rc

  if ! grep -q '^prepare_installer() {$' "$file"; then
    return 2
  fi

  tmp="$(mktemp)" || return 1
  awk -v repl="$replacement" '$0=="prepare_installer() {"{print repl; skip=1; next} skip{if($0=="}") skip=0; next} {print}' "$file" >"$tmp"
  rc=$?

  if [[ $rc -eq 0 ]]; then
    mv "$tmp" "$file"
  else
    rm -f "$tmp"
  fi

  return $rc
}
