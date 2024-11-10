let
  pkgs = import <nixpkgs> {};
in pkgs.mkShell {
  name = "nixos-config";
  buildInputs = with pkgs; [
    colmena

    nix
    home-manager
    git

    sops
    ssh-to-age
    gnupg
    age

    nixd
  ];
}