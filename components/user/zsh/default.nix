{
  pkgs,
  customLib,
  config,
  ...
} : let 
  lib = customLib; 
  cfg = config.programs.zsh;
in {
  options.programs.zsh.p10k = {
    enable = lib.mkEnableOption "Enable p10k";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enableCompletion = lib.mkDefault true;
      autosuggestion.enable = lib.mkDefault true;
      syntaxHighlighting.enable = lib.mkDefault true;

      plugins = lib.mkIf cfg.p10k.enable [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = ./config;
          file = "p10k.zsh";
        }
      ];

      oh-my-zsh = {
        enable = true;
        plugins = [
          "kubectl"
          "rsync"
          "git"
          "bundler"
          "dotenv"
          "rake"
          "rbenv"
          "ruby"
          "catimg"
          "colorize"
          "command-not-found"
          "cp"
          "emoji"
          "git-extras"
          "history-substring-search"
          "jsontools"
          "last-working-dir"
          "postgres"
          "sudo"
          "vscode"
          "direnv"
        ];
      };
    };
  };
}