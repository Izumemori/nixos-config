{
  inputs,
  lib,
  pkgs,
  nodeConfig,
  ...
} : let 
  listToAttrs = list: (builtins.listToAttrs (map (value: {name = value.name; inherit value; }) list));
in {
  # Generic home-manager config
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.verbose = true;  

  users.users = lib.attrsets.genAttrs (lib.map (v: v.name) nodeConfig.users) (
    username: let
      user = (listToAttrs nodeConfig.users).${username};
    in {
      extraGroups = lib.mkIf user.config.allowRoot ["wheel"];
      isNormalUser = true;
      openssh.authorizedKeys.keys = user.config.opensshKeys;
    }
  );

  nix.settings.trusted-users = [ "@wheel" ] 
    ++ map (v: v.name) (builtins.filter (x: x.config.trusted) (map (v: v) nodeConfig.users));

  # defaults for all users
  home-manager.users = lib.attrsets.genAttrs (lib.map (v: v.name) nodeConfig.users) (
    username: let 
      user = (listToAttrs nodeConfig.users).${username};
    in {
      imports = user.config.components;
      home = with user.config; {
        username = user.name;
        homeDirectory = lib.mkIf home.enabled home.path;
        stateVersion = "24.11";
      };
    }
  );
}