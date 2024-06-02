{
  inputs,
  outputs, 
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs outputs;
  };
  modules = [
    ./configuration.nix
    ./hardware.nix

    ../common

    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];
}