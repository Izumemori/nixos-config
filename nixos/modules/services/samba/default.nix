_: {
  pkgs,
  lib,
  config,
  ...
} : let 
  cfg = config.services.samba;

  base_mnt = "/shares";

  share = path:
  {
    device = "//carbon.ad.izu.re/${path}";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in [ "${automount_opts},credentials=/etc/nixos/smb-secrets,vers=3.0,rw,uid=1000,soft,rsize=8192,wsize=8192,mfsymlinks" ];
  };
in {
  options.services.samba = with lib; with types; {
    enableClient = mkEnableOption "Enable Samba";
  };

  config = lib.mkIf cfg.enableClient {
    environment.systemPackages = [ pkgs.cifs-utils ];
    fileSystems = {
      "${base_mnt}/programming" = share "programming";
      "${base_mnt}/edu" = share "caesium-edu";
      "${base_mnt}/media" = share "media";
      "${base_mnt}/backup" = share "backup";
      "${base_mnt}/vault" = share "vault";
    }; 
  };
}