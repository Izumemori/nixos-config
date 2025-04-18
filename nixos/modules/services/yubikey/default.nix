_: {
  pkgs,
  lib,
  config,
  ...
} : let 
  cfg = config.services.yubikey;
in {
  options.services.yubikey = with lib; with types; {
    enable = mkEnableOption "Enable Yubikey support";
  };

  config = lib.mkIf cfg.enable {
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

        # Yubico's official tools
        yubioath-flutter
      ];
    };

    users.groups.input.members = builtins.attrNames config.home-manager.users;
  };
}