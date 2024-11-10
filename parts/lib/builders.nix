{
  inputs,
  lib,
  ...
} : let
  inherit (inputs) self nixpkgs;
  inherit (lib) mkDefault;
  inherit (lib.lists) concatLists singleton forEach;
  inherit (lib.attrsets) recursiveUpdate;

  mkNodeModules = {
      profile,
      users ? [ lib.users.sam ],
      components ? [],
      extraModules ? []
    }: let
    in (lib.lists.singleton profile._path)
      ++ (map (val: val._path) users)
      ++ (map (val: val._path) components)
      ++ extraModules; 

  mkNode = node: {
    withSystem
  }: let 
    nodeOptions = import (node._path + "/options.nix") { inherit inputs lib mkNodeModules; };
  in withSystem nodeOptions.system ({
    inputs',
    self',
    ...
  }: lib.nixosSystem {
    specialArgs = {
        inherit inputs self inputs' self' nodeOptions;
        inherit (self) lib;
        #packages = config.packages;
    };

    modules = nodeOptions.modules
      ++ singleton (node._path)
      ++ singleton {
        networking.hostName = nodeOptions.hostname;
        
        nixpkgs = {
          hostPlatform = mkDefault nodeOptions.system;
          flake.source = nixpkgs.outPath;
          config.allowUnfree = true;
        };
        nix.settings = {
          experimental-features = [ "nix-command" "flakes" ];
        };

        time.timeZone = "Europe/Berlin";
        system.stateVersion = "24.11";
      }
      ++ [
        inputs.home-manager.nixosModules.home-manager
        ({
          inputs',
          self',
          self,
          config,
          lib,
          ...
        }: {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.sharedModules = [ 
            { 
              nix.package = lib.mkForce config.nix.package;
              programs.home-manager.enable = true;
            } ];
          home-manager.extraSpecialArgs = {
            inherit (self) inputs;
            inherit inputs' self self'; 
          };
        })
      ];
  });
in {
  inherit mkNode;
}