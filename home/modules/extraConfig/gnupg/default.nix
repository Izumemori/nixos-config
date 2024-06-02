_: {
  pkgs,
  lib,
  config,
  osConfig,
  ...
} : let 
  cfg = config.extraConfig.gnupg;
in {
  options.extraConfig.gnupg = {
    enable = lib.mkEnableOption "Enable gnupg config";
  };

  config = lib.mkIf cfg.enable {
    home.file.".gnupg" = {
      source = ./config;
      recursive = true;
    };
  };
}