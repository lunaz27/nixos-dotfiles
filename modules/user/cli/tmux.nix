{
  flake.homeModules."tmux" =
    {
      pkgs,
      ...
    }:

    {
      programs.tmux = {
        enable = true;

        # Native configuration
        baseIndex = 1;
        keyMode = "vi";
        terminal = "tmux-256color";
        shell = "${pkgs.fish}/bin/fish";

        # Native plugins
        plugins = with pkgs.tmuxPlugins; [
          sensible
          vim-tmux-navigator
          yank
          resurrect
          continuum
        ];

        # Custom binds and styling
        extraConfig = ''
          # Vim-like pane navigation
          bind-key h select-pane -L
          bind-key j select-pane -D
          bind-key k select-pane -U
          bind-key l select-pane -R

          # Kitty integration
          set-option -a terminal-features 'kitty:RGB'

          # Consistency pane border
          set-option -g pane-border-style "fg=#45475b,bg=default"
          set-option -g pane-active-border-style "fg=#45475b,bg=default"

          # Allow tmux to set the host terminal window's title
          set-option -g set-titles on
          set-option -g set-titles-string "#T"

          # Extra base-index settings to catch panes
          set -g pane-base-index 1
          set-window-option -g pane-base-index 1
          set-option -g renumber-windows on
          # Status bar configuration
          set -g status off
          set -g status-style bg=default
          set -g status-right ""
          set -g status-left ""
          set -g status-justify centre
          set -g pane-border-line single
          set-option -g status-position top

          # Vim-like keybindings for yanking text
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        '';
      };
    };
}
