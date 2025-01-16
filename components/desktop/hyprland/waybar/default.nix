{ inputs, config, pkgs, customLib, nodeConfig, ... }: let 
  lib = customLib; 
  
  settings = import ./settings.nix { inherit pkgs; };
  style = import ./style.nix {};
in {
  home-manager.users = lib.attrsets.genAttrs (lib.map (v: v.username) (lib.filter (u: u.home.enable) nodeConfig.users)) (username: {
    programs.waybar = {
    enable = true;
    inherit settings style;
    };
  });
}