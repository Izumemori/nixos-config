{
    description = "Sam's nix flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixos-hardware.url = "github:nixos/nixos-hardware";
        sops = {
            url = "github:mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

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
                sops, 
                ...
            }: let
                inherit (self) outputs;
            in {
                nixosConfigurations = {
                    iodine = import ./systems/iodine { inherit inputs outputs; };
                };
            };
}
