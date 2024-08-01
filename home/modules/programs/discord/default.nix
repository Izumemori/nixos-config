_: {
  pkgs,
  lib,
  config,
  osConfig,
  ...
} : let 
  cfg = config.programs.discord;
  res = import ./nixos.nix osConfig;
in {
  _file = ./default.nix;

  options.programs.discord = {
    enable = lib.mkEnableOption "Enable discord";
  };

  config = lib.mkIf cfg.enable {
    home.file."${config.xdg.configHome}/discordcanary" = {
      source = ./discord-config;
      recursive = true;
      force = true;
    };
    
    home.packages = with pkgs; [
      discord-canary
    ];
  };
}