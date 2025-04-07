{inputs, profiles, users, components}: {
  hostname = "BROD-EROHLIJ";
  domain = "ge.eu.spsx.com";
  system = "x86_64-linux";
  profile = profiles.interactive;
  users = with users; [ 
    colmena
    sam
  ];
  components = with components; with desktop; [
    development.yubikey
  ];
  extraModules = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
  ];
}