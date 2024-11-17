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
      inherit (node.config) users extraModules;
      components = node.config.components ++ node.config.profile.config.components;
    };
  in withSystem node.config.system ({
    inputs',
    self',
    config,
    ...
  }: lib.nixosSystem {
    specialArgs = {
        inherit inputs self inputs' self';
        nodeConfig = node.config;
        customLib = lib;
        packages = config.packages;
    };

    modules = modules
      ++ singleton (node._path)
      ++ singleton {
        networking.hostName = node.config.hostname;
        
        nixpkgs = {
          hostPlatform = mkDefault node.config.system;
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
        ../../users/default.nix
        ({
          inputs',
          self',
          self,
          config,
          lib,
          ...
        }: {
          home-manager.sharedModules = [ 
            { 
              nix.package = lib.mkForce config.nix.package;
              programs.home-manager.enable = true;
            } 
          ];

          home-manager.extraSpecialArgs = {
            inherit (self) inputs;
            inherit inputs' self self'; 
            customLib = lib;
            nodeConfig = node.config;
          };
        })
      ];
  });
in {
  inherit mkNode;
}