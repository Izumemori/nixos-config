{
  config,
  lib,
  nodeConfig,
  ...
}: let
  cfg = config.services.plex;
in { 
  options.services.plex = {
    nodeUser = lib.mkOption { 
      type = lib.types.oneOf nodeConfig.users; 
      description = "The user to run plex under";  
    };
  };

  config = lib.mkIf cfg.enable {
    services.plex = rec {
      openFirewall = true;
      user = lib.mkForce cfg.nodeUser.username;
      group = lib.mkDefault config.users.users.${user.content}.group;
    };
  };
}