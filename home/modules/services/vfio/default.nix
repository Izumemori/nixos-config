inputs: {
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
    #virtualisation = {
    #  libvirt = {
    #    swtpm.enable = true;
    #    connections."qemu://session".domains = [
    #      {
    #        definition = config.nixvirt.lib.domain.writeXML(lib.callPackage ./domains/atlasos.nix inputs);
    #      }
    #    ];
    #  };
    #};

    nixpkgs.config = {
      environment.systemPackages = with pkgs; [
        virt-manager
        qemu
        OVMFFull
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
          connections."qemu:///system".domains = [
            {
              definition = config.nixvirt.lib.domain.writeXML(lib.callPackage ./domains/atlasos.nix inputs);
              active = false;
            }
          ];
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
  };
}