_: {
  pkgs,
  lib,
  config,
  ...
} : let 
  cfg = config.programs.steam;
in {
  config = lib.mkIf cfg.enable {
    programs.steam = {
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;

      gamescopeSession.enable = true;
    };

    hardware.opengl = {
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = [ pkgs.amdvlk ];
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };
  };
}