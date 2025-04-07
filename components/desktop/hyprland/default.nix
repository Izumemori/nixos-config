{ inputs, config, pkgs, customLib, nodeConfig, ... }: let 
  lib = customLib; 
  hyprland-pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;

      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };
  
  hardware.graphics = {
    package = hyprland-pkgs.mesa.drivers;
    enable32Bit = true;
    package32 = hyprland-pkgs.pkgsi686Linux.mesa.drivers;
  };

  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
    };

    dbus.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;
    };
  };

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    hyprlock
    hyprpicker
    hyprcursor
    hypridle
    hyprpaper
    walker
    copyq
    hyprshot
    playerctl
    xwaylandvideobridge
    banana-cursor
    vscode
    firefox
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji-blob-bin
    nerd-fonts.fira-code
    fira-math

    dolphin
    kitty

  ];

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  home-manager.users = lib.attrsets.genAttrs (lib.map (v: v.username) (lib.filter (u: u.home.enable) nodeConfig.users)) (username: import ./user.nix);
}