#

## misc

- [ ] finish snapshots.nix module
- [ ] configure sops
- [ ] declare secrets with sops-nix
- [x] configure ssh agent to have my key (or maybe gpg agent? to manage ssh keys)
- [ ] create separate module for gpg-agent or just structer ssh/gpg better
- [ ] create go module (and maybe for other languages) - define dependacies, make neovim lsp dependent on this module
- use pretty git logging like this?:
  > git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

## ui

- [x] fix weird icons in gtk apps (pavucontrol specifically)
- [ ] fix cursor in gtk apps? (scilab specifically)

## quickshell

have you seen example of such apply function, or why did you implemented ┃
┃ it?l

### screenshot script

- [ ] in screenshot script - display selected area pixel count outside of the selected area
- [ ] remove cursor capturing in screenshot script
- [ ] remove overlay appearance animation for the screenshot script

## Neovim

- [x] treesitter for tsx
- [x] lsp keybinds
- [ ] A to append + automatically indent to the proper level
- [ ] rebinding p and P to automatically format lines when they're pasted
- [ ] find and figure out new go to definition keymap
- [ ] set up formatting with neovim lsp instead of conform?

## zsh

- [x] cant move with tab on cd <tab>
- [x] create fzf-git-files() files for copmletion, like this?

## Backup

- [x] windows vm
- [x] ssh keys?
- [x] gpg keys
