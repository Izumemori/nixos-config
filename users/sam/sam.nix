{
  lib,
  pkgs,
  osConfig,
  ...
}: { 
  home = {
    username = lib.users.sam._name;
    homeDirectory = "/home/sam";
    stateVersion = "24.11";
  };
}