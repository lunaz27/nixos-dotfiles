{
  flake.homeModules."fzf" = {
    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;

      defaultOptions = [
        "--layout=reverse"
        "--border=rounded"
      ];

      historyWidget.options = [
        "--height=80%"
        "--layout=reverse"
        "--border=rounded"
        "--prompt='󰋚 History: '"
        "--with-nth=2.."
        "--preview='echo {3..} | fish_indent --ansi'"
        "--preview-window='right:50%:wrap'"
        "--bind='ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'"
      ];
    };
  };
}
