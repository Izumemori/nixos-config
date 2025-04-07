{ config, pkgs, customLib, ... } : let lib = customLib; in {
  imports = [
    ./formats/proxmox.nix
  ];

  # Extra packages
  environment.systemPackages = [
    pkgs.btop
  ];

  # Limit generations to 5
  boot.loader.generic-extlinux-compatible.configurationLimit = 5;

  # Clean up old store paths after 7 days
  nix.gc = {
    automatic = true;
    persistent = false;
    dates = "daily";
    options = "--delete-older-than 7d";
  };
}