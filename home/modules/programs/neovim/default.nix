_: {
  pkgs,
  lib,
  config,
  osConfig,
  ...
} : let 
  cfg = config.programs.neovim;
in {
  _file = ./default.nix;

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      viAlias = true;
      vimAlias = true;

      plugins = [

      ];
    };
  };
}