_: {
  pkgs,
  lib,
  config,
  osConfig,
  ...
} : let 
  cfg = config.extraConfig.ssh;
in {
  options.extraConfig.ssh = {
    enable = lib.mkEnableOption "Enable ssh config";
  };

  config = {
    home.file.".ssh" = {
      source = ./config;
      recursive = true;
    };
  };
}