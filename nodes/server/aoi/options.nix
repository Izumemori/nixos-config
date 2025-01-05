{inputs, profiles, users, components}: {
  hostname = "aoi";
  domain = "dmz.local.izu.re";
  system = "aarch64-linux";
  profile = profiles.server;
  nixpkgs = inputs.nixpkgs-stable;
  users = with users; [ 
    sam
    colmena 
  ];
  components = with components; with server; [
    ssh
    plex
    navidrome
    audiobookshelf
    syncthing
  ];
  extraModules = with inputs.nixos-hardware.nixosModules; [
    raspberry-pi-4
    "${inputs.nixpkgs-stable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];
}