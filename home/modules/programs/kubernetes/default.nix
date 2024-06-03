_: {
  pkgs,
  lib,
  config,
  osConfig,
  ...
} : let 
  cfg = config.programs.kubernetes;
in {
  _file = ./default.nix;

  options.programs.kubernetes = {
    enable = lib.mkEnableOption "Enable kubernetes";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kubectl
      lens
    ];
  };
}