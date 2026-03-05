## usage: log <level> <message...>
log() {
  : "${log_level:=${SSI_LOG_LEVEL:-info}}"

  local level="$1"
  shift
  local msg="$*"
  local caller color_func rank_req rank_cur

  case "$level" in
    debug) rank_req=10 ;;
    info) rank_req=20 ;;
    warn) rank_req=30 ;;
    error) rank_req=40 ;;
    *) rank_req=20 ;;
  esac

  case "$log_level" in
    debug) rank_cur=10 ;;
    info) rank_cur=20 ;;
    warn) rank_cur=30 ;;
    error) rank_cur=40 ;;
    *) rank_cur=20 ;;
  esac

  # filter by level
  [[ $rank_req -lt $rank_cur ]] && return 0

  # choose color function
  color_func="cyan"
  case "$level" in
    debug) color_func="magenta" ;;
    info) color_func="green" ;;
    warn) color_func="yellow_bold" ;;
    error) color_func="red_bold" ;;
  esac

  if [[ "$log_level" == "debug" ]]; then
    caller="${FUNCNAME[1]}"
    printf "$(green_bold "•") %s • %s $(green_bold →) %s\n" \
      "$("$color_func" "$level")" "$(cyan "$caller")" "$msg" >&2
  else
    printf "$(green_bold "•") %s $(green_bold →) %s\n" \
      "$("$color_func" "$level")" "$msg" >&2
  fi
}

## usage: fail <message...>
fail() {
  log error "$*"
  return 1
}
