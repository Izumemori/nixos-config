{inputs, profiles, users, components}: {
  hostname = "db";
  domain = "ge.eu.spsx.com";
  IP = "10.247.57.82";
  system = "x86_64-linux";
  profile = profiles.server;
  nixpkgs = inputs.nixpkgs;
  users = with users; [ 
    sam
    colmena 
  ];
  components = with components; with server; [
    ssh
  ];
  extraModules = with inputs.nixos-hardware.nixosModules; [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/proxmox-image.nix"
  ];
}