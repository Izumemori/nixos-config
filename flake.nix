{
    description = "Sam's nix flake";

    inputs = {
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixos-hardware.url = "github:nixos/nixos-hardware/master";
        chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
        #hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
        sops = {
            url = "github:mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        #VScode - nil
        nil.url = "github:oxalica/nil";
        nixos-vscode-server.url = "github:msteen/nixos-vscode-server";

        catppuccin.url = "github:catppuccin/nix";

        home-manager = {
            url = "github:nix-community/home-manager/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixvirt = {
            url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        spicetify-nix = {
            url = "github:Gerg-L/spicetify-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{
                self,
                nixpkgs,
                nixpkgs-stable,
                home-manager,
                catppuccin,
                nixos-hardware,
                sops,
                nixvirt,
                spicetify-nix,
                #hyprland,
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
