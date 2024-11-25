{
  inputs,
  lib,
  ...
} : let
  inherit (inputs) self nixpkgs;
  inherit (lib) mkDefault;
  inherit (lib.lists) singleton;

  mkNodeModules = {
      users ? [ lib.users.sam ],
      components ? [],
      extraModules ? []
    }: let
    in (map (val: val._path) users)
      ++ (map (val: val._path) components)
      ++ extraModules; 

  mkNode = node: {
    withSystem
  }: let 
    modules = mkNodeModules {
      inherit (node) users extraModules;
      components = node.components ++ node.profile.components;
    };
  in withSystem node.system ({
    inputs',
    self',
    config,
    ...
  }: lib.nixosSystem {
    specialArgs = {
        inherit inputs self inputs' self';
        nodeConfig = node // { inherit lib; };
        customLib = lib;
        packages = config.packages;
    };

    modules = modules
      ++ singleton (node._path)
      ++ singleton {
        networking.hostName = node.hostname;
        
        nixpkgs = {
          hostPlatform = mkDefault node.system;
          flake.source = nixpkgs.outPath;
          config.allowUnfree = true;
        };
        nix.settings = {
          experimental-features = [ "nix-command" "flakes" ];
        };

        # Default user config
        users.users = lib.attrsets.genAttrs (lib.map (v: v.name) node.users) (
          username: let
            user = (lib.concatListToAttrs node.users).${username};
          in {
            extraGroups = lib.mkIf user.allowRoot ["wheel"];
            isNormalUser = true;
            openssh.authorizedKeys.keys = user.opensshKeys;
          }
        );

        nix.settings.trusted-users = [ "@wheel" ] 
          ++ map (v: v.name) (builtins.filter (x: x.trusted) (map (v: v) node.users));

        time.timeZone = "Europe/Berlin";
        system.stateVersion = "24.11";
      };
  });
in {
  inherit mkNode;
}