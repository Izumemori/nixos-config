{ config, pkgs, customLib, nodeConfig, ... }: let 
  lib = customLib; 
  cfg = config.services.yubikey;
in {
  options.services.yubikey = {
     nodeUser = lib.mkOption { 
      type = lib.types.oneOf nodeConfig.users; 
      description = "The user to run plex under";  
    };
  };

  config = {
     nixpkgs.overlays = [
      (self: super: {
        # Fix Flutter for yubioath-flutter
        flutter = super.flutter319;
      })
    ];

    programs = {
      ssh.startAgent = false;

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = pkgs.pinentry-qt;
      };
    };

    hardware = {
      gpgSmartcards.enable = true;
    };

    services = {
      pcscd.enable = true;
      udev.packages = [ pkgs.yubikey-personalization ];
    };

    security.polkit = {
      debug = true;
      enable = lib.mkForce true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                  action.id == "org.debian.pcsc-lite.access_card" ||
                  action.id == "org.debian.pcsc-lite.access_pcsc"
                )
              ) 
          {
            return polkit.Result.YES;
          }
        });
      '';
    };

    environment = {
      shellInit = ''
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      '';
      
      systemPackages = with pkgs; [
        gnupg

        yubioath-flutter
      ];
    };

    users.groups.input.members = lib.singleton cfg.nodeUser.username;

    home-manager.users.${cfg.nodeUser.username} = {
      home.file.".gnupg" = {
        source = ./.gnupg;
        recursive = true;
      };
    };
  };
}