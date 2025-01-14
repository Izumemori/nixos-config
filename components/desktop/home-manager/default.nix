{
  inputs,
  inputs',
  self,
  self',
  config,
  lib,
  customLib,
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
      customLib = customLib;
      inherit nodeConfig;
    };

    users = lib.attrsets.genAttrs (lib.map (v: v.username) (lib.filter (u: u.home.enable) nodeConfig.users)) (
      username: let 
        user = customLib.users.${username};
      in {
        imports = user.components;
        home = with user; {
          username = user.username;
          homeDirectory = lib.mkIf home.enable home.path;
          stateVersion = builtins.substring 0 5 nodeConfig.nixpkgs.lib.version;
        };
      }
    );
  };
}