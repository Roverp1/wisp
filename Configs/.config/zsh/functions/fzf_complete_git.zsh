_fzf_complete_git() {
    ARGS="$@"
    if [[ $ARGS == "git add"* ]]; then
        _fzf_complete --reverse --multi -- "$@" < <(
            git ls-files --modified --others --exclude-standard
        )
    elif [[ $ARGS == "git restore"* ]]; then
        _fzf_complete --reverse --multi -- "$@" < <(
            git ls-files --modified
        )
    elif [[ $ARGS == 'git rm'* ]]; then
        _fzf_complete --reverse --multi -- "$@" < <(
            git ls-files
        )
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

_fzf_complete_git_post() {
    awk '{print $1}'
}

fzf-git-files() {
    local words=(${(z)LBUFFER})

    if [[ ${words[1]} == "git" ]]; then
        local subcmd=(${words[2]})
        local files=""

        case "$subcmd" in
        diff | restore)
            files=$(git ls-files --modified)
            ;;
        add)
            files=$(git ls-files --modified --others --exclude-standard)
            ;;

        *)
            files=$(git ls-files)
            ;;
        esac

        if [[ -n $files ]]; then
            local selected=$(echo "$files" | fzf \
                --multi \
                --height=100% \
                --reverse \
                --preview 'git diff --color=always {} 2>/dev/null | tail -n +5 || cat {}' \
                --preview-window=right,50%,border-sharp,wrap
            )

            if [[ -n $selected ]]; then
                LBUFFER="$LBUFFER${selected//$'\n'/ } "
                zle reset-prompt
            fi
        fi
    fi
}
