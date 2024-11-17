{ 
  lib,
  config,
  pkgs,
  ...
}: {
  # Enable printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [        
       epson-escpr
       epsonscan2
       epson-escpr2
    ];
  };

  # Printer autodiscovery
  services.avahi = lib.mkDefault {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}