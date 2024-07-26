{
    description = "Sam's nix flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
        nixos-hardware.url = "github:nixos/nixos-hardware/master";
        sops = {
            url = "github:mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        #VScode - nil
        nil.url = "github:oxalica/nil";
        nixos-vscode-server.url = "github:msteen/nixos-vscode-server";

        catppuccin.url = "github:catppuccin/nix";

        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixvirt = {
            url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        spicetify-nix.url = "github:the-argus/spicetify-nix";
    };

    outputs = inputs@{
                self,
                nixpkgs,
                home-manager,
                catppuccin,
                nixos-hardware,
                sops,
                nixvirt,
                spicetify-nix,
                ...
            }: let
                inherit (self) outputs;
            in {
                nixosConfigurations = {
                    iodine = import ./systems/iodine { inherit inputs outputs; };
                    krypton = import ./systems/krypton {inherit inputs outputs; };
		};
            };
}
