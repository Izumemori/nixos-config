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

    usbip = {
      enable = true;
      autoAttach = [ "3-6" ]; # Lower front USB
    };
  };

  services.yubikey = {
    nodeUser = lib.users.sam;
  };

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +5d";
  };
}