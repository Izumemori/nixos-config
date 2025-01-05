{
  config,
  lib,
  nodeConfig,
  ...
}: let
  cfg = config.services.audiobookshelf;
in { 
  options.services.audiobookshelf = {
    nodeUser = lib.mkOption { 
      type = lib.types.oneOf nodeConfig.users; 
      description = "The user to run audiobookshelf under";  
    };
  };

  config = lib.mkIf cfg.enable {
    services.audiobookshelf = rec {
      openFirewall = true;
      user = lib.mkForce cfg.nodeUser.username;
      group = lib.mkDefault config.users.users.${user.content}.group;
    };
  };
}