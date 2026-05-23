# shellcheck shell=bash
# Bash/zsh/ash specific: define / as a function for slash command dispatch
# This file is only sourced by shells that support / in function names

/(){
    ___x_cmd_slash_runname "$@"
}

___x_cmd_slash___def(){
    local name="$1"
    local fp="$2"
    eval "/$name(){
        ___x_cmd_slash_run \"$fp\"
    }"
}
