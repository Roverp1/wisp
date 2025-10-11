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
