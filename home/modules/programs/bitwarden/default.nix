_: {
  pkgs,
  lib,
  config,
  osConfig,
  ...
} : let 
  cfg = config.programs.bitwarden;
in {
  _file = ./default.nix;

  options.programs.bitwarden = {
    enable = lib.mkEnableOption "Enable Bitwarden";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bitwarden
    ];
  };
}