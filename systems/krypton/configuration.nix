{ 
  pkgs,
  inputs,
  config,
  ...
}: {
  networking = {
    hostName = "krypton";
    firewall.enable = true;
    hostId = "12345678";
  };

  environment.systemPackages = with pkgs; [
    corectrl
    hyprlock
    mangohud
  ];

  services = {
    vfio = {
      enable = true;
      pciIDs = [
      ];
      isosPath = "/home/sam/.vm/isos/";
      storagePath = "/home/sam/.vm/storage/";
      nvramPath = "/home/sam/.vm/nvram/";
      user = "sam";
      kvmfr.enable = false;
    };
  };

  chaotic.mesa-git.enable = true;

  hardware.firmware = with pkgs; [
    (linux-firmware.overrideAttrs (old: {
      src = builtins.fetchGit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "710a336b31981773a3a16e7909fd83daeaec9db1"; # Uncomment this line to allow for pure builds
      };
    }))
  ];

  system.stateVersion = "24.05";
}
