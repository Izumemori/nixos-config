_: {
  pkgs,
  lib,
  config,
  ...
} : let 
  cfg = config.services.vfio;
in {
  options.services.vfio = with lib; with types; {
    enable = mkEnableOption "Enable VM";
    pciIDs = mkOption {
      type = listOf str; 
      description = "PCI ids to blacklist";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      virt-manager
      qemu
    ];

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };

    boot = {
      kernelModules = [ "kvm-amd" ];

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