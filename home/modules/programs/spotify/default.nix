inputs: {
  pkgs,
  lib,
  config,
  ...
} : let 
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  cfg = config.programs.spotify;
in {
  options.programs.spotify = with lib; with types; {
    enable = mkEnableOption "Enable Spotify";
  };
  config = lib.mkIf cfg.enable {
    nixpkgs.config = {
      environment.systemPackages = [
        pkgs.spotify
      ];

      networking.firewall = {
        allowedTCPPorts = [ 57621 ];
        allowedUDPPorts = [ 5353 ];
      };
    };

    programs.spicetify = {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
      ];
    };
  };
}