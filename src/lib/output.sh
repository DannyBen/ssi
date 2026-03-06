## usage: say <label> <message...>
say() {
  local label="$1"
  shift
  printf "%s: %s\n" "$(green_bold "$label")" "$*"
}

## usage: warn <label> <message...>
warn() {
  local label="$1"
  shift
  printf "%s: %s\n" "$(yellow_bold "$label")" "$*"
}
