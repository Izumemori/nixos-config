{
  config,
  pkgs,
  lib,
  nodeConfig,
  customLib,
  ...
} : {
  environment.systemPackages = with pkgs; [
    firefox
  ];

  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    desktopManager.plasma6.enable = true;
    
    dbus = {
      enable = true;
      implementation = "dbus";
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;
    };
  };

  networking = {
    networkmanager.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.fira-code
    #fira-math
  ];

  security.polkit.enable = true;
}