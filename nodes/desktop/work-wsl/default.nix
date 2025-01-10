{ config, pkgs, customLib, ... }: let lib = customLib; in {
  environment.systemPackages = with pkgs; [
    wget
    git
    socat
  ];

  wsl = {
    enable = true;
    defaultUser = lib.users.sam.username;
    docker-desktop.enable = true;
  };

  services.yubikey = {
    nodeUser = lib.users.sam;
  };
}