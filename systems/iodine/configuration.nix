{ 
  pkgs,
  inputs,
  config,
  ...
}: {
  networking = {
    hostName = "iodine";
    firewall = {
      enable = false;
      allowedTCPPorts = [ 47984 47989 47990 48010 ];
      allowedUDPPortRanges = [
        { from = 47998; to = 48000; }
        { from = 8000; to = 8010; }
      ];
    };
  };

  services = {
    sunshine = {
      enable = true;
      capSysAdmin = true;
      autoStart = true;
    };

    wireguard.enable = true;

    fwupd.enable = true;
  };

  system.stateVersion = "24.05";
}