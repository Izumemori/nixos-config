{
  inputs,
  pkgs,
  osConfig,
  ...
}: {
  extraConfig = {
    gnupg.enable = true;
    ssh.enable = true;
  };

  waybar.enable = true;
  
  programs = {
    kitty = {
      enable = true;
      shellIntegration = {
        enableZshIntegration = true;
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
      };
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
    p10k.enable = true;
    home-manager.enable = true;

    git = {
      enable = true;
      userEmail = "sam@rohli.ng";
      userName = "Sam Rohling";
      extraConfig = {
        user.signingkey = "0x8915fc124cf78a58";
        safe.directory = "*";
      };
    };

    discord.enable = true;  
    bitwarden.enable = true;
    kubernetes.enable = true;
    spotify.enable = true;
  };

  home = {
    username = "sam";
    homeDirectory = "/home/sam";
    stateVersion = "24.05";
  };
}