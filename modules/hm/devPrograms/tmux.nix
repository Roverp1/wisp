{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.programs.tmux;
in {
  options.wisp.programs.tmux = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable tmux module";
    };
  };

  config = let
    userIcon = "";
    sessionIcon = "";
    uploadSpeedIcon = "󰕒";
    leftArrowIcon = "";
    rightArrowIcon = "";
    downloadSpeedIcon = "󰇚";
    timeIcon = "";
    dateIcon = "";

    prefixPrompt = "PREFIX";

    base00 = config.lib.stylix.colors.withHashtag.base00;
    base01 = config.lib.stylix.colors.withHashtag.base01;
    base02 = config.lib.stylix.colors.withHashtag.base02;
    base03 = config.lib.stylix.colors.withHashtag.base03;
    base04 = config.lib.stylix.colors.withHashtag.base04;
    base05 = config.lib.stylix.colors.withHashtag.base05;
    base06 = config.lib.stylix.colors.withHashtag.base06;
    base07 = config.lib.stylix.colors.withHashtag.base07;
    base08 = config.lib.stylix.colors.withHashtag.base08;
    base09 = config.lib.stylix.colors.withHashtag.base09;
    base0A = config.lib.stylix.colors.withHashtag.base0A;
    base0B = config.lib.stylix.colors.withHashtag.base0B;
    base0C = config.lib.stylix.colors.withHashtag.base0C;
    base0D = config.lib.stylix.colors.withHashtag.base0D;
    base0E = config.lib.stylix.colors.withHashtag.base0E;
  in
    lib.mkIf cfg.enable {
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
          # {
          #   plugin = prefix-highlight;
          #   extraConfig = ''
          #     set -g @prefix_highlight_prefix_prompt "PREFIX"
          #     set -g @prefix_highlight_copy_prompt "COPY"
          #
          #     set -g @prefix_highlight_show_copy_mode "on"
          #     set -g @prefix_highlight_copy_mode_attr "fg=${base0D},bg=${base00},bold"
          #     set -g @prefix_highlight_output_prefix "#[fg=${base0D},bg=${base00}]${leftArrowIcon}#[fg=${base00},bg=${base0D}]"
          #     set -g @prefix_highlight_output_suffix "#[fg=${base0D},bg=${base00}]${rightArrowIcon}"
          #   '';
          # }
          net-speed
        ];

        extraConfig = let
          timeFormat = "%I:%M %p";
          dateFormat = "%F";

          baseConfig = ''
            # window and pane indexing
            set -g base-index 1
            set -g renumber-windows on
            set -g pane-base-index 1

            # enable true colors
            set -g default-terminal "tmux-256color"
            set -ga terminal-overrides ",*:Tc"

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

            set -g pane-border-style "fg=${base03},bg=default"
            set -g pane-active-border-style "fg=${base0D},bg=default"

            set -g display-panes-colour "${base03}"
            set -g display-panes-active-colour "${base0D}"

            # Clock mode
            set -g clock-mode-colour "${base0D}"
            set -g clock-mode-style 12

            # Message
            set -g message-style "fg=${base0D},bg=${base00}"

            # Command message
            set -g message-command-style "fg=${base0D},bg=${base00}"

            # Copy mode highlight
            set -g mode-style "bg=${base0D},fg=${base05}"
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

          # TC (accent) = base0D (blue)
          # G0 (darkest bg) = base00
          # G1 = base01
          # G2 = base02
          # G3 = base03
          # G4 (text) = base05

          statusBar = ''
            set -g @user_icon           ""
            set -g @session_icon        ""
            set -g @upload_speed_icon   "󰕒"
            set -g @left_arrow_icon     ""
            set -g @right_arrow_icon    ""
            set -g @download_speed_icon '󰇚'
            set -g @time_icon           ""
            set -g @date_icon           ""

            set -g status-interval 1
            set -g status-style fg="#{@base05}",bg="#{@base00}",none
            set -g status on

            set -g status-left-style bg="#{@base00}"
            set -g status-right-style bg="#{@base00}"

            set -g status-left-length 150
            set -g status-right-length 150

            ${leftStatus}
            ${rightStatus}

            # Window status
            set -g window-status-format "#[fg=#{@base00},bg=#{@base02}]#{@right_arrow_icon} #[fg=#{@base0D},bg=#{@base02}] #I:#W#F #[fg=#{@base02},bg=#{@base00}]#{@right_arrow_icon}"
            set -g window-status-current-format "#[fg=#{@base00},bg=#{@base0D}]#{@right_arrow_icon} #[fg=#{@base00},bg=#{@base0D},bold] #I:#W#F #[fg=#{@base0D},bg=#{@base00},nobold]#{@right_arrow_icon}"

            set -g window-status-separator ""

          '';

          leftStatus = "set -g status-left \"${userHostModule}${sessionModule}${uploadSpeedModule}\"";

          rightStatus = "set -g status-right \"${prefixHighlightModule}${downloadSpeedModule}${timeModule}${dateModule}\"";

          userHostModule = "#[fg=#{@base00},bg=#{@base0D},bold] #{@user_icon} #(whoami)@#h #[fg=#{@base0D},bg=#{@base02},nobold]#{@right_arrow_icon}";
          sessionModule = "#[fg=#{@base0D},bg=#{@base02}] #{@session_icon} #S ";
          uploadSpeedModule = "#[fg=#{@base02},bg=#{@base01}]#{@right_arrow_icon}#[fg=#{@base0D},bg=#{@base01}] #{@upload_speed_icon} #{upload_speed} #[fg=#{@base01},bg=#{@base00}]#{@right_arrow_icon}";

          prefixMode = "#[fg=#{@base01},bg=#{@base00}]${leftArrowIcon}#[fg=${base00},bg=${base0D}] ${prefixPrompt} ";
          prefixHighlightModule = "#{?client_prefix,${prefixMode}, }";

          downloadSpeedModule = "#[fg=${base0D},bg=${base00}]#{@left_arrow_icon}#[fg=#{@base0D},bg=#{@base01}] #{@download_speed_icon} #{download_speed} ";
          timeModule = "#[fg=#{@base02}]#{@left_arrow_icon}#[fg=#{@base0D},bg=#{@base02}] #{@time_icon} ${timeFormat} #[fg=#{@base0D},bg=#{@base02}]#{@left_arrow_icon}";
          dateModule = "#[fg=#{@base00},bg=#{@base0D}] #{@date_icon} ${dateFormat} ";
        in ''
          ${base16Colors}
          ${baseConfig}
          ${statusBar}
        '';
      };
    };
}
