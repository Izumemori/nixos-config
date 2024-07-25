_: {
  pkgs,
  lib,
  config,
  ...
} : let 
  cfg = config.services.samba;
in {
  options.services.samba = with lib; with types; {
    enableClient = mkEnableOption "Enable Samba";
  };

  config = lib.mkIf cfg.enableClient {
    environment.systemPackages = [ pkgs.cifs-utils ];
    fileSystems."/shares/programming" = {
      device = "//carbon.ad.izu.re/programming";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in [ "${automount_opts},credentials=/etc/nixos/smb-secrets,rw,uid=1000" ];
    };
  };
}