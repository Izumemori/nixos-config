{
  pkgs,
  inputs,
  config,
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
        discord-canary-overlay = super.discord-canary.overrideAttrs (_: { 
            src = builtins.fetchTarball {
              url = "https://discord.com/api/download/canary?platform=linux&format=tar.gz";
              sha256 = "192scvdsc7mx78wcg4ywpjyv4gcmqmj5g55yr7mkmdysf969xwwd";
            };
          });
        vscode = enableWayland super.vscode "code";
        discord-canary = enableWayland self.discord-canary-overlay "DiscordCanary";
      })
    ];

  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    desktopManager.plasma6.enable = true;

    sunshine = {
      enable = true;
      capSysAdmin = true;
      autoStart = true;
    };

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
  };

  networking = {
    networkmanager.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    (nerdfonts.override { fonts = ["FiraCode"]; })
  ];
  
  environment.systemPackages = with pkgs; [
    mpv
    git
    libnotify
    glances

    firefox

    zsh

    wget
    unzip

    virt-manager

    vscode
    nil

    sudo

    catppuccin-kde
  ];

  catppuccin.flavor = "mocha";
  catppuccin.enable = true;

  programs = {    
    zsh = {
      enable = true;
    };
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
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