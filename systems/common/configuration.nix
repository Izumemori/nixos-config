{
  pkgs,
  inputs,
  config,
  lib,
  ...
} : {
  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
    
    users.sam = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "dialout"
        "docker"
        "video"
        "uucp"
        "libvirtd"
        "adbusers"
      ];
    };
  };

  # TODO: Move into proper config
   nixpkgs.overlays = [
      (self:
      let
        enableWayland = drv: bin: drv.overrideAttrs (
          old: {
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ self.makeWrapper ];
            postFixup = (old.postFixup or "") + ''
              wrapProgram $out/bin/${bin} \
                --add-flags "--enable-features=UseOzonePlatform" \
                --add-flags "--ozone-platform=wayland"
            '';
          }
        );
      in
       super: { 
        vscode = enableWayland super.vscode "code";
      })
    ];

  programs = {
    steam.enable = true;
    adb.enable = true;
    ausweisapp2 = {
      enable = true;
      openFirewallPorts = true;
    };
  };

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

    yubikey.enable = true;

    usbmuxd.enable = true;

    samba.enableClient = true;

    udev.packages = [
      pkgs.android-udev-rules
    ];
  };

  networking = {
    networkmanager.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    (nerdfonts.override { fonts = ["FiraCode"]; })
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      kdePackages.fcitx5-qt
      fcitx5-mozc
    ];
    
  };

  environment.systemPackages = with pkgs; [
    mpv
    git
    libnotify
    glances
    hyfetch

    firefox
    thunderbird
    parsec-bin

    zsh

    wget
    unzip

    virt-viewer
    spice 
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    virtiofsd

    vscode
    nil

    sudo

    catppuccin-kde

    lm_sensors

    sops

    jetbrains.rider

    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
    ];
    
  programs = {    
    zsh = {
      enable = true;
    };

    virt-manager.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    spiceUSBRedirection.enable = true;
  };

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        efiSupport = true;
        device = "nodev";
      };
    };
    initrd = {
      systemd.dbus.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  time.timeZone = "Europe/Berlin";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";
}