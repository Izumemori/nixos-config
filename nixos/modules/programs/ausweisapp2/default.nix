_: {
  pkgs,
  lib,
  config,
  ...
} : let 
  cfg = config.programs.ausweisapp2;
in {
  options.programs.ausweisapp2 = {
    enable = lib.mkEnableOption "Enable Ausweisapp2";
    openFirewallPorts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "If enabled opens the necessary ports for remote card reader connections";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.AusweisApp2
    ];

    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewallPorts [
      24727
    ];
  };
}