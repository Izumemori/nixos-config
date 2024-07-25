{ 
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./configuration.nix
    inputs.catppuccin.nixosModules.catppuccin
    inputs.home-manager.nixosModules.home-manager
    inputs.NixVirt.nixosModules.default
    inputs.sops.nixosModules.sops
    {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.sam = {
            imports = [
                inputs.catppuccin.homeManagerModules.catppuccin
                inputs.sops.homeManagerModules.sops
                inputs.NixVirt.homeModules.default
            ] ++ builtins.attrValues (import ../../home/modules inputs)
            ++ [
                ./users/sam.nix
            ];
        };
    }
  ] ++ builtins.attrValues (import ../../nixos/modules inputs);
}