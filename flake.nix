{
  ###
  ##  Inspiration:
  ##    - https://github.com/NotAShelf/nyx (especially flake-parts)
  ### 
  description = "Izu's nix flake";

  outputs = inputs@{self, ...}: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = import inputs.systems;

    imports = [
      ./nodes
      ./parts
    ];
  };

  inputs = {
    ###
    ##  Infrastructure
    ###
    # Systems, defined here so it can be followed
    systems.url = "github:nix-systems/default-linux";

    # Nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nix WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # Hardware specific fixes
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Used for splitting up the flake
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    # Generators
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ###
    ##  Applications
    ###
    # Nixvirt
    nixvirt = {
        url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spicetify
    spicetify-nix = {
        url = "github:Gerg-L/spicetify-nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    catppuccin.url = "github:catppuccin/nix";
  };
}