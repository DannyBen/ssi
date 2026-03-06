level="${args[level]}"
eval "message=(${args[message]})"

log "$level" "${message[@]}"
