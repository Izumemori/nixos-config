{inputs, profiles, users, components}: {
  hostname = "iodine";
  domain = "lan.local.izu.re";
  system = "x86_64-linux";
  profile = profiles.interactive;
  users = with users; [ 
    sam
    colmena 
  ];
  components = with components; [
    virtualisation
    desktop.hyprland
  ];
  extraModules = with inputs.nixos-hardware.nixosModules; [
    framework-13-7040-amd
  ];
}