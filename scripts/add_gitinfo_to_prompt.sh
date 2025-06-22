#!/bin/bash

# Function to parse git branch or tag
function parse_git_ref {
    local ref
    ref=$(git symbolic-ref -q --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null)

    if [[ $? -ne 0 || $ref = '' ]]; then
        if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            ref="detached:$(git rev-parse --short HEAD)"
        else
            ref=''
        fi
    fi

    echo "$ref"
}

# Function to parse git user
function parse_git_user {
    local user
    user=$(git config user.name 2>/dev/null)
    if [[ $? -ne 0 ]]; then
        user=''
    fi

    echo "$user"
}

# Set the bash prompt
__bash_prompt() {
    local BLUE='\[\e[1;34m\]'
    local RED='\[\e[1;31m\]'
    local GREEN='\[\e[1;32m\]'
    local WHITE='\[\e[00m\]'
    local GRAY='\[\e[1;37m\]'
    local RMCOLOR='\[\033[0m\]'

    local BASE="\u@\h"
    PS1="${GREEN}${BASE}${WHITE}:${BLUE}\w${GREEN} (\$(parse_git_ref))(\$(parse_git_user))${WHITE}\$ "

    case "$TERM" in
    xterm* | rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *) ;;
    esac

    unset -f __bash_prompt
}
__bash_prompt
