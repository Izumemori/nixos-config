{
  config,
  lib,
  nodeConfig,
  pkgs,
  ...
}: let 
  cfg = config.services.navidrome;

  apiSubmodule = {
    options = {
      enable = lib.mkOption {
        description = "Enable API support";
        type = lib.types.bool;
        default = false;
      };

      apiKeyPlaceholder = lib.mkOption {
        description = ''
          The API Key

          If the secret is defined like `sops.secrets."navidrome/lastfm/key"` then this value should be "navidrome/lastfm/key".
        '';
        type = lib.types.str;
        default = "";
      };

      apiSecretPlaceholder = lib.mkOption {
        description = ''
          The API Secret

          If the secret is defined like `sops.secrets."navidrome/lastfm/secret"` then this value should be "navidrome/lastfm/secret".
        '';
        type = lib.types.str;
        default = "";
      };
    };
  };

  configSubmodule = {
    options = {
      lastfm = lib.mkOption {
        description = "The LastFM submodule";
        type = lib.types.submodule apiSubmodule;
      };

      spotify = lib.mkOption {
        description = "The Spotify submodule";
        type = lib.types.submodule apiSubmodule;
      };

      host = lib.mkOption {
        description = "The IP the service should bind to";
        type = lib.types.str;
        default = "0.0.0.0";
      };

      port = lib.mkOption {
        description = "The port to bind to";
        type = lib.types.port;
      };

      musicFolder = lib.mkOption {
        description = "Where the music is stored";
        type = lib.types.str;
      };
    };
  };
in {
  options.services.navidrome = {
    nodeUser = lib.mkOption {
      type = lib.types.oneOf nodeConfig.users;
      description = "The user to run plex under";
    };

    config = lib.mkOption {
      type = lib.types.submodule configSubmodule;
    };
  };

  config = lib.mkIf cfg.enable {
    services.navidrome = {
      settings = {
        host = lib.mkForce "0.0.0.0";
        port = lib.mkForce cfg.config.port;
      };
      group = lib.mkDefault config.users.users.${cfg.nodeUser.username}.group;
    };

    sops.templates."navidrome-config.toml" = {
      content = 
      ''
        Address = '${cfg.config.host}'
        Port = ${toString cfg.config.port}
        MusicFolder = '${cfg.config.musicFolder}'
      '' + lib.optionalString cfg.config.lastfm.enable 
      ''
        [LastFM]
        Enabled = true
        ApiKey = '${config.sops.placeholder."${cfg.config.lastfm.apiKeyPlaceholder}"}'
        Secret = '${config.sops.placeholder."${cfg.config.lastfm.apiSecretPlaceholder}"}'
      '' + lib.optionalString cfg.config.spotify.enable
      ''
        [Spotify]
        ID = '${config.sops.placeholder."${cfg.config.spotify.apiKeyPlaceholder}"}'
        Secret = '${config.sops.placeholder."${cfg.config.spotify.apiSecretPlaceholder}"}'
      '';
      owner = cfg.nodeUser.username;
    };

    systemd.services.navidrome.serviceConfig = lib.mkForce {
      ExecStart = "${lib.getExe pkgs.navidrome} --configfile=${config.sops.templates."navidrome-config.toml".path}";
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.config.port ];
  };
}