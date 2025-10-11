#

- [ ] finish snapshots.nix module

##

- [x] fix weird icons in gtk apps (pavucontrol specifically)
- [ ] configure ssh agent autostart

## Neovim

- [ ] treesitter for tsx
- [x] lsp keybinds
- [ ] A to append + automatically indent to the proper level
- [ ] rebinding p and P to automatically format lines when they're pasted

## zsh

- [ ] create fzf-git-files() files for copmletion, like this?

```zsh
fzf-git-files() {
    # Check if we're completing a git command
    local words=(${(z)LBUFFER})
    if [[ ${words[1]} == "git" ]]; then
        local subcmd=${words[2]}
        local files=""

        case "$subcmd" in
            diff|restore)
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
            local selected=$(echo "$files" | fzf --multi --preview 'git diff --color=always {} 2>/dev/null || cat {}')
            if [[ -n $selected ]]; then
                LBUFFER="$LBUFFER$selected "
                zle reset-prompt
            fi
        fi
    fi
}

```

## Backup

- [x] windows vm
- [x] ssh keys?
- [x] gpg keys
