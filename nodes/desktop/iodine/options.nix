{inputs, lib, mkNodeModules}: {
  hostname = "iodine";
  domain = "lan.local.izu.re";
  system = "x86_64-linux";
  modules = mkNodeModules {
    profile = lib.profiles.mobile;
    users = with lib.users; [ 
      sam
      colmena 
    ];
    components = with lib.components; [
      virtualisation
      desktop.hyprland
    ];
    extraModules = with inputs.nixos-hardware.nixosModules; [
      framework-13-7040-amd
    ];
  };
}