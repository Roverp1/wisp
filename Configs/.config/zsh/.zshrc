WORDCHARS="_"

# Options
setopt extended_glob
setopt glob_dots

# History
setopt hist_reduce_blanks
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Key binds
bindkey -e

bindkey "^f" autosuggest-accept
