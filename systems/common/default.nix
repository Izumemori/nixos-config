{ 
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ../../nixos/theme.nix

    ./configuration.nix
    inputs.catppuccin.nixosModules.catppuccin
    inputs.home-manager.nixosModules.home-manager
    inputs.nixvirt.nixosModules.default
    inputs.sops.nixosModules.sops
    {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.sam = {
            imports = [
                inputs.catppuccin.homeManagerModules.catppuccin
                inputs.sops.homeManagerModules.sops
                inputs.nixvirt.homeModules.default
                inputs.spicetify-nix.homeManagerModule
            ] ++ builtins.attrValues (import ../../home/modules inputs)
            ++ [
                ./users/sam.nix
                (import ../../home/theme.nix inputs)
            ];
        };
    }
  ] ++ builtins.attrValues (import ../../nixos/modules inputs);
}