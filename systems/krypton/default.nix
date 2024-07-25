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
  ];
}
