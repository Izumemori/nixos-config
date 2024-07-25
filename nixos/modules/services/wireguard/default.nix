_: {
  pkgs,
  lib,
  config,
  ...
} : let 
  cfg = config.services.wireguard;
in {
  options.services.wireguard = with lib; with types; {
    enable = mkEnableOption "Enable Wireguard";
  };

  config = lib.mkIf cfg.enable {
    networking.wg-quick.interfaces = {
      home = {
        autostart = true;
        address = [ "10.10.1.1/32" "fd::10:10:1:1/128" ];
        dns = [ "10.0.0.247" ];
        privateKeyFile = "/root/wireguard/private.key";

        peers = [
          {
            publicKey = "ljn5FDAbf1Gs5CrLlBJoPBNAXGqiiBYkqv7V0NNR9lk=";
            presharedKeyFile = "/root/wireguard/preshared.key";
            allowedIPs = [ "0.0.0.0/0" "::/0" ];
            endpoint = "local.izu.re:587";
            persistentKeepalive = 25;
          }
        ];
      };
    };
    systemd.services.wg-quick-home = {
      wantedBy = [ "network-online.target" ];
      serviceConfig = {
        Type =  lib.mkForce "simple";
        Restart = "on-failure";
        RestartSec = "5s";
        RemainAfterExit = true;
      };
    };
  };
}