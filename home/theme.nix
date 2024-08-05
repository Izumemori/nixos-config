inputs: {
  pkgs,
  lib,
  config,
  ...
} : let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};

  flavor = "mocha";
  accent = "peach";
  enable = true;
in {

  config = {
    ### General
    # Home
    catppuccin = {
      inherit enable flavor accent;

      pointerCursor = {
        inherit enable flavor accent;
      };
    };    
    
    ### Programs
    # Fcitx
    i18n.inputMethod.fcitx5.catppuccin = {
      inherit enable flavor;
    };

    # Kitty
    programs.kitty.catppuccin = lib.mkIf config.programs.kitty.enable {
      inherit enable flavor;
    };

    # Spotify
    programs.spicetify = lib.mkIf config.programs.spicetify.enable {
      theme = spicePkgs.themes.catppuccin;
      colorScheme = flavor;
    };

    ### DE
    # GTK
    gtk.catppuccin = {
      inherit enable flavor accent;
      icon = {
        inherit enable flavor accent;
      };
      size = "standard";
    };

    # QT
    qt.style.catppuccin = {
      inherit enable flavor accent;
    };

  };
}