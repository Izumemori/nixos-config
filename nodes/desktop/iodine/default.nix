{ config, pkgs, customLib, ... } : let lib = customLib; in {
  imports = [
    ./hardware.nix
  ];

  services.yubikey.nodeUser = lib.users.sam;
}