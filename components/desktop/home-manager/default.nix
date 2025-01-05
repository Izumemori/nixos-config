{
  inputs,
  inputs',
  self,
  self',
  config,
  lib,
  nodeConfig, 
  ... 
}: with nodeConfig.lib; {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;  

    sharedModules = [ 
      { 
        nix.package = lib.mkForce config.nix.package;
        programs.home-manager.enable = true;
      } 
    ];

    extraSpecialArgs = {
      inherit (self) inputs;
      inherit inputs' self self'; 
      customLib = lib;
      inherit nodeConfig;
    };

    users = lib.attrsets.genAttrs (lib.map (v: v.name) nodeConfig.users) (
      username: let 
        user = (concatListToAttrs nodeConfig.users).${username};
      in {
        imports = user.components;
        home = with user; {
          username = user.name;
          homeDirectory = lib.mkIf home.enable home.path;
          stateVersion = "24.11";
        };
      }
    );
  };
}