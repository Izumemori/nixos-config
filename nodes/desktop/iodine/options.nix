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
    desktop.home-manager
    desktop.hyprland
    development.yubikey
  ] ++ (with components.desktop.hyprland; [
    waybar
  ]);
  extraModules = with inputs.nixos-hardware.nixosModules; [
    framework-13-7040-amd
  ];
}