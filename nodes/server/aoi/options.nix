{inputs, profiles, users, components}: {
  hostname = "aoi";
  domain = "dmz.local.izu.re";
  system = "aarch64-linux";
  profile = profiles.server;
  users = with users; [ 
    sam
    colmena 
  ];
  components = with components; [
    server.ssh
    server.plex
  ];
  extraModules = with inputs.nixos-hardware.nixosModules; [
    raspberry-pi-4
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];
}