{inputs, profiles, users, components}: {
  hostname = "work-wsl";
  domain = "";
  system = "x86_64-linux";
  profile = profiles.server;
  users = with users; [ 
    colmena
    sam
  ];
  components = with components; with server; [
    vscode-remote
    development.yubikey
    desktop.home-manager
  ];
  extraModules = [
    inputs.nixos-wsl.nixosModules.default
  ];
}