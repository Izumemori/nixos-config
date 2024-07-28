inputs:{  
  pkgs,
  lib,
  config,
  ...
} : let 
  cfg = config.services.vfio;

  moduleConfig = {
    config = cfg;
    nixvirt = inputs.nixvirt;
    lib = lib;
  };
in {
  options.services.vfio = with lib; with types; {
    enable = mkEnableOption "Enable VM";
    pciIDs = mkOption {
      type = listOf str; 
      description = "PCI ids to blacklist";
    };
    isosPath = mkOption {
      type = str;
      description = "Path to the iso pool";
    };
    storagePath = mkOption {
      type = str;
      description = "Path to the pool";
    };
    nvramPath = mkOption {
      type = str;
      description = "Path to the nvram storage";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      virt-manager
      qemu
      OVMFFull

      # for switching the input on my monitor
      ddcutil
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [pkgs.OVMFFull.fd];
          };
        };
      };
      libvirt = {
        enable = true;
        swtpm.enable = true;
        connections."qemu:///system" = {
          networks = import ./networks moduleConfig;
          domains = import ./domains moduleConfig;
          pools = import ./pools moduleConfig;
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.isosPath} 0770 sam users -"
      "d ${cfg.storagePath} 0770 sam users -"
      "d ${cfg.nvramPath} 0770 sam users -"
    ];

    boot = {
      kernelModules = [ "kvm-amd" "i2c-dev" ];

      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];

      kernelParams = [
        "amd_iommu=on"
      ];

      extraModprobeConfig = ''
        options kvm_amd avic=1 nested=0 sev=0
        options vfio-pci ids=${lib.concatStringsSep "," cfg.pciIDs}
      '';
    };
  };
}