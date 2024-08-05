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
    inputs.nixvirt.nixosModules.default
    inputs.spicetify-nix.nixosModules.default
    inputs.sops.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.sam = {
            imports = [
                inputs.catppuccin.homeManagerModules.catppuccin
                inputs.sops.homeManagerModules.sops
                inputs.nixvirt.homeModules.default
                inputs.spicetify-nix.homeManagerModules.default
            ] ++ builtins.attrValues (import ../../home/modules inputs)
            ++ [
                ./users/sam.nix
                (import ../../home/theme.nix inputs)
            ];
        };
    }
  ] ++ builtins.attrValues (import ../../nixos/modules inputs);
}