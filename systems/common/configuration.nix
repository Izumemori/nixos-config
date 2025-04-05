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
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+eLx0zFwIEHVso57SwBXr5TmpM8kVQbb7FpMgpNWqpYKC92pzHeM+FFYAPy399arb+H0QIFDBXBX87CdTyOA3yZP0eEAtWNGFifWPIlpQj9gjdszdABc8qkREyTtYobBlT6uV4yICQw7IywALZIgq3M+qr5EDsUiDuWMAg/2GeA+sxmg+VaszqauS4LEhE1YK56oFq9IXB9UkohobVh0WjHbFz7iH6ER+CrntSkfnYlj+E5hg+bvNNXGvsvtAFWyQcy5B1iUoZkv7FFA/2L91mpoT2WiFsRpmEoH8NDmCrF5C8D4Gy6CfGUGNtWoKtXLhDlQECb4aZ6IbXoEfKmq416s+1ug7aB6m4K2qHS7OQfye/I8DqvFnvorhnO5fHvG1cIs+GI10AknkJ/UT+IWJjw2Y6j6blqFpEmgWgmjmQL+MRteRdAcOcerLVNTRPG3PENXBkff9FEsqQJdhJExHBr7lriX8jIw5TRJ0Xg305fnoYq3yoih2Ybc0jbescNO/x8tE9JdpVO3ElwG24zWSrXm4GIwMADwU4JH3um0R2NzxVIX6zzwncewIWC8BTD91cWw/fNAmdwSVCXcfIxS3CJ8dyOVNMdvBa9Ct2j+/lDaADM0VJiJM4vjLE4NMp22KHRnvwAa4C+dQx/LBxn8SeazQOzW2wOaR4pyXUogYyQ== cardno:14_236_673"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDgrjAlpsC1uhLuDHqqaeF+jkpmd01DTpqrdR0FSRxvZu75dRi/KH2brv0+Sgd7tdKyiRjgTwTnDlOna7QXVOa4U6aXXLNZA1DBlhy0FcSZKOc3KXOSkbkaoNSsBPje6/3GZEwpAgBGkzrF+mtSgsCqF+sczHkdf7HdiXrMNGSyhizi+0h3OZVzOvJOt4KxRmzH8UsTyZfut8lXZryj7+OZY0bJ7bKw6idOklzdj2gvNjmInZjfmomgdYdpIlSLFouCfX6ZIUOAEhfySbkmCQRuB+Z9yf9vwKRYUj0SL9115f5UWoPePschcRrvmcolNa9dnqDlWR83MqKm2jKRhYZMIIRyqMAJCFNXEXol6a9+pc59dBGF7v2KyNRVus+X8/PPOG1kJdI6LTSm1446gwmDkKg3WLiUXwyF3Ie8UDkmfawk08KyzuH5NcxNtQ6R0zVHFKh+Um7c1dbYQFv0mXwbfDzNZ6RShRponBfcNIjArzbGQ5WPLsksPQGxTwBkAe5KOr8pRwPhjxcNWfRK/HbONxEdUUovnMcKaIplRe2UuxfpJF6FjRNXh+TY4ReLUT9YvIH7ddV/ijzkEzMyOEZKw/TILenfFjPLiueQfmAuJ1NO631f3t+nKg8qITb1ZDhmVS/RZaFpdBSfavDb9zlNfZ4h4rIduQ/DOr1y4b2+bQ== cardno:23_509_748"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOmzwQWIkq7vW+c0MKoHmCsZ24bNvfZZgn8Pim7fdWAT sam@iodine"
      ];
    };
  };
  nix.settings.trusted-users = [ "sam" "@wheel" ];
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = true;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };
  # TODO: Move into proper config
   nixpkgs.overlays = [
      (final: prev: {
        lldb = prev.lldb.overrideAttrs {
        dontCheckForBrokenSymlinks = true;
        };
      })

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

        forceX11 = drv: bin: drv.overrideAttrs (
          old: {
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ self.makeWrapper ];
            postFixup = (old.postFixup or "") + ''
              wrapProgram $out/bin/${bin} \
                --set XDG_SESSION_TYPE x11
            '';
          }
        );
      in
       super: { 
        vscode = enableWayland super.vscode "code";
        discord-canary = forceX11 super.discord-canary "discordcanary";
      })
    ];

  programs = {
    steam.enable = true;
    adb.enable = true;
    ausweisapp2 = {
      enable = true;
      openFirewallPorts = true;
    };
    kdeconnect.enable = true;
    #hyprland = {
    #  enable = true;
    #  xwayland.enable = true;
    #  #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    #  #portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    #};
    nix-ld = {
      enable = true;
    };
    gphoto2.enable = true;
  };

  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    gvfs.enable = true;
    tumbler.enable = true; 

    #xserver = {
    #  enable = true;
    #  displayManager.gdm.enable = true;
    #};
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
    nerd-fonts.fira-code
    #fira-math
  ];

  #i18n.inputMethod = {
  #  enabled = "fcitx5";
  #  fcitx5.waylandFrontend = true;
  #  fcitx5.addons = with pkgs; [
  #    kdePackages.fcitx5-qt
  #    fcitx5-mozc
  #  ];
  #  
  #};

  environment.systemPackages = with pkgs; [
    easyeffects

    vulkan-hdr-layer-kwin6

    mpv
    git
    libnotify
    glances
    hyfetch

    firefox
    thunderbird
    parsec-bin
    zsh

    gparted

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
    kdePackages.ark

    jetbrains.rider
    jetbrains.idea-ultimate
    jetbrains.clion
    
    libimobiledevice
    ifuse # optional, to mount using 'ifuse'

    android-studio

    gimp
    kdePackages.okular

    playerctl
    pavucontrol
    kdePackages.xwaylandvideobridge

    cachix

    distrobox
    banana-cursor

    tidal-hifi

    veracrypt
  ];
    
  security.polkit.enable = true;
services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;

  security.pam.loginLimits = [
    { domain = "*"; item = "nofile"; type = "-"; value = "65536"; }
    { domain = "*"; item = "memlock"; type = "-"; value = "65536"; }
  ];
  systemd.user.extraConfig = "DefaultLimitNOFILE=32768";
  programs = {
    
    zsh = {
      enable = true;
    };

    virt-manager.enable = true;

    thunar = {
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
      enable = true;
    };

    xfconf.enable = true;
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
        useOSProber = true;
      };
    };
    initrd = {
      systemd.dbus.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_testing;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      epson-escpr
    ];
  };

  # autodiscovery of printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  time.timeZone = "Europe/Berlin";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";
  services.hardware.openrgb.enable = true;
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
}
