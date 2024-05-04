#!/bin/bash

# Added for displaying git branch in prompt
function parse_git_branch {
    local ret=

    ret=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

    if [[ $? -ne 0 ]]; then
        ret=''
    elif [[ $ret = 'HEAD' ]]; then
        ret="detached:$(git rev-parse --short HEAD)"
    fi

    echo "$ret"
}

__bash_prompt() {
    local BLUE='\[\e[1;34m\]'
    local RED='\[\e[1;31m\]'
    local GREEN='\[\e[1;32m\]'
    local WHITE='\[\e[00m\]'
    local GRAY='\[\e[1;37m\]'
    local RMCOLOR='\[\033[0m\]'

    local BASE="\u@\h"
    PS1="${GREEN}${BASE}${WHITE}:${BLUE}\w${GREEN} (\$(parse_git_branch))${WHITE}\$ "

    case "$TERM" in
    xterm* | rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *) ;;
    esac

    unset -f __bash_prompt
}
__bash_prompt
