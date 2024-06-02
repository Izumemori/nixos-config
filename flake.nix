{
    description = "Sam's nix flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixos-hardware.url = "github:nixos/nixos-hardware";
        agenix.url = "github:ryantm/agenix";

        #VScode - nil
        nil.url = "github:oxalica/nil";
        nixos-vscode-server.url = "github:msteen/nixos-vscode-server";

        catppuccin.url = "github:catppuccin/nix";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{
                self,
                nixpkgs,
                home-manager,
                catppuccin,
                nixos-hardware,
                agenix, 
                ...
            }: let
                inherit (self) outputs;
            in {
                nixosConfigurations = {
                    iodine = import ./systems/iodine { inherit inputs outputs; };
                };
            };
}
