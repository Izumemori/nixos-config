{inputs, profiles, users, components}: {
  hostname = "test";
  domain = "";
  port = 2222;
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
  extraModules = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
    inputs.catppuccin.nixosModules.catppuccin
  ];
}