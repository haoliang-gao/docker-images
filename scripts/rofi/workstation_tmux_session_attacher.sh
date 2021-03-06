#!/usr/bin/env bash

show_options() {
    create_default_session_if_necessary &>/dev/null
    list_sessions
}

list_sessions() {
    INTERACTIVE_TTY="" $UTIL_DIR/attach.sh tmux list-session -F '#{session_name}' 2>&1
}

create_default_session_if_necessary() {
    list_sessions | grep '^default$' &>/dev/null || {
        INTERACTIVE_TTY="" $UTIL_DIR/attach.sh tmux new-session -d -c "$HOME" -s default
    }
}

active_option() {
    local session=${1:?requires session name}

    local mutex_option=""
    if [ $MUTEX -ne 0 ]; then
        mutex_option="-d"
    fi

    coproc {
        $UTIL_DIR/workstation.sh session "$session" $mutex_option
    }

    local in=${COPROC[1]}
    exec {in}>&-
}

main() {

    case $# in
        0)
            show_options
            ;;
        *)
            active_option "$@"
            ;;
    esac

}

ROOT=$(dirname $(realpath $0))
UTIL_DIR=$(realpath $ROOT/..)
MUTEX=${MUTEX:-1}

main "$@"
