{ config, pkgs, customLib, ... } : let lib = customLib; in {
  environment.systemPackages = [
      pkgs.wget
  ];
  
  programs.nix-ld = {
      enable = true;
  };
}