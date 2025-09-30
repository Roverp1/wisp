{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.roverp.programs.tmux;
in {
  options = {
    roverp.programs.tmux = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable tmux module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      prefix = "C-b";
      baseIndex = 1;
      keyMode = "vi";
      mouse = true;

      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        open
        vim-tmux-navigator
        resurrect
        {
          plugin = tmux-sessionx;
          extraConfig = ''
            set -g @sessionx-bind "o"
            set -g @sessionx-zoxide-mode 'on'
            set -g @sessionx-filter-current 'false'
            # set -g @sessionx-ls-command       "exa --oneline --icons --sort=type"
          '';
        }
        {
          plugin = prefix-highlight;
        }
      ];

      extraConfig = let
        baseConfig = ''
          # window and pane indexing
          set -g base-index 1
          set -g renumber-windows on
          set -g pane-base-index 1

          # enable true colors
          # set -sa terminal-overrides ",xterm*:Tc"
          set-option -g default-terminal 'screen-256color'
          set-option -g terminal-overrides ',xterm-256color:RGB'

          set-window-option -g mode-keys vi
          bind  -T copy-mode-vi    v           send -X begin-selection
          bind  -T copy-mode-vi    C-v         send -X rectangle-toggle
          bind  -T copy-mode-vi    y           send-keys -X copy-selection-and-cancel
          bind  -T copy-mode-vi    Escape      send -X cancel

          bind  -T prefix   R       run-shell 'tmux source-file ~/.config/tmux/tmux.conf && tmux display-message "✔ Config reloaded!" || tmux display-message "⚠ Error reloading config!"'

          # Enter resize mode
          bind -T prefix r switch-client -T resize

          # Define the 'resize' key table
          bind -r -T resize h resize-pane -L 2
          bind -r -T resize l resize-pane -R 2
          bind -r -T resize j resize-pane -D 2
          bind -r -T resize k resize-pane -U 2
          bind -T resize Escape switch-client -T prefix
        '';

        base16Colors = ''
          set -g @base00 "${config.lib.stylix.colors.withHashtag.base00}"
          set -g @base01 "${config.lib.stylix.colors.withHashtag.base01}"
          set -g @base02 "${config.lib.stylix.colors.withHashtag.base02}"
          set -g @base03 "${config.lib.stylix.colors.withHashtag.base03}"
          set -g @base04 "${config.lib.stylix.colors.withHashtag.base04}"
          set -g @base05 "${config.lib.stylix.colors.withHashtag.base05}"
          set -g @base06 "${config.lib.stylix.colors.withHashtag.base06}"
          set -g @base07 "${config.lib.stylix.colors.withHashtag.base07}"
          set -g @base08 "${config.lib.stylix.colors.withHashtag.base08}"
          set -g @base09 "${config.lib.stylix.colors.withHashtag.base09}"
          set -g @base0A "${config.lib.stylix.colors.withHashtag.base0A}"
          set -g @base0B "${config.lib.stylix.colors.withHashtag.base0B}"
          set -g @base0C "${config.lib.stylix.colors.withHashtag.base0C}"
          set -g @base0D "${config.lib.stylix.colors.withHashtag.base0D}"
          set -g @base0E "${config.lib.stylix.colors.withHashtag.base0E}"
        '';

        statusBar = ''

          set -g @user_icon           ' '
          set -g @session_icon        ' '
          set -g @upload_speed_icon   '󰕒'
          set -g @left_arrow_icon     ''
          set -g @right_arrow_icon    ''
          set -g @download_speed_icon '󰇚'
          set -g @time_icon           ' '
          set -g @date_icon           ' '

          set -g status-interval 1
          set -g status-style fg="#{base05}",bg="#{base00}",none
          status on

          set -g status-left-style bg="#{base05}",bold
          set -g status-right-style

          set -g status-left-length 150
          set -g status-right-length 150

        '';
      in ''
        ${base16Colors}
        ${baseConfig}
      '';
    };
  };
}
