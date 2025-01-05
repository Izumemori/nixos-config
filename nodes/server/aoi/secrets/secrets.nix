{ config, pkgs, lib, ... }: let 
  secrets = {
    format = "yaml";
    sopsFile = ./secrets.yaml;
  };
in {
  sops.secrets = {
    "syncthing-key" = {
      format = "binary";
      sopsFile = ./syncthing-key.pem;
    };

    "syncthing-cert" = {
      format = "binary";
      sopsFile = ./syncthing-cert.pem;
    };

    "navidrome/lastfm/key" = secrets;
    "navidrome/lastfm/secret" = secrets;
    "navidrome/spotify/id" = secrets;
    "navidrome/spotify/secret" = secrets;
    "bonob/secret" = secrets;
  };
}