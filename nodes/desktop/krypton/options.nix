{inputs, lib, mkNodeModules}: {
  hostname = "krypton";
  domain = "lan.local.izu.re";
  system = "x86_64-linux";
  modules = mkNodeModules {
    profile = lib.profiles.desktop;
    users = with lib.users; [
      sam
      colmena
    ];
    components = with lib.components; [
      virtualisation
      desktop.hyprland
    ];
  };
}