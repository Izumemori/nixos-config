{
  customLib,
  pkgs,
  ...
}: let lib = customLib; in { 
  catppuccin = { 
    enable = true;
    flavor = "mocha";
  };

  fonts.fontconfig.enable = true;

  programs = {
    nix-your-shell = {
      enable = true;
      enableZshIntegration = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      font = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode NF";
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      p10k.enable = true;
    };

    git = {
      enable = true;
      userEmail = "sam@rohli.ng";
      userName = "Sam Rohling";
      extraConfig = {
        user.signingkey = "0x8915fc124cf78a58";
        safe.directory = "*";
      };
    };

    gpg = let 
      gpgKey = pkgs.fetchurl {
        url = "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x8915fc124cf78a58";
        hash = "sha256-JsBLOkmmgvw1Ya3QfPQL7/VriH9sYGT5/uMQaKwJh9w=";
      };
    in {
      enable = true;
      publicKeys = [
        {
          source = gpgKey.outPath;
          trust = 5;
        }
      ];
    };
  };
}