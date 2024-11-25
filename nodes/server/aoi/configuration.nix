{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  nodeConfig, 
  ... 
}: { 
  services.plex = {
    enable = true;
    nodeUser = nodeConfig.lib.users.sam;
  };
}