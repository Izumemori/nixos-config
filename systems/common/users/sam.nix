{
  inputs,
  pkgs,
  osConfig,
  ...
}: {

  catppuccin.enable = true;

  extraConfig = {
    gnupg.enable = true;
    ssh.enable = true;
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
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
          "adb"
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
      };
    };

    discord.enable = true;  
    bitwarden.enable = true;
    qgis.enable = true;
    
    ssh.matchBlocks = {
      "uni.dmz.local.izu.re" = {
        hostname = "uni.dmz.local.izu.re";
        user = "sam";
        forwardAgent = true;
      };
    };
  };

  home = {
    username = "sam";
    homeDirectory = "/home/sam";
    stateVersion = "24.05";
  };
}