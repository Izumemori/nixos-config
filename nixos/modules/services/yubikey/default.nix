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

    environment = {
      shellInit = ''
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      '';
      
      systemPackages = with pkgs; [
        gnupg

        # Yubico's official tools
        yubikey-manager
        yubikey-manager-qt
        yubikey-personalization
        yubikey-personalization-gui
        yubico-piv-tool
        yubioath-flutter
      ];
    };

    users.groups.input.members = builtins.attrNames config.home-manager.users;
  };
}