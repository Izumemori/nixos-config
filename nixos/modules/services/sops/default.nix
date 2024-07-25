_: {
  pkgs,
  lib,
  config,
  ...
} : let 
  cfg = config.services.sops;
in {
  options.services.sops = with lib; with types; {
    enable = mkEnableOption "Enable Sops";
  };

  config = lib.mkIf cfg.enable {
    sops.gnupg.home = "/var/lib/sops";
    sops.gnupg.sshKeyPaths = [];

    sops.secrets.sam_password = {
      sopsFile = ./secrets/user.yaml;
      neededForUsers = true;
      format = "yaml";
    };
  };
}