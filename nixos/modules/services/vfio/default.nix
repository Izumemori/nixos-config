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

    user = mkOption {
      type = types.str;
      default = "root";
      description = "Owner of the files and folders";
    };
    group = mkOption {
      type = types.str;
      default = "qemu-libvirtd";
      description = "Group of the files and folders";
    };

    kvmfr = {
      enable = mkEnableOption "Enable kvmfr";

      size = mkOption {
        type = types.int;
        default = 64;
        description = "Size of the shared memory device in megabytes.";
      };
      mode = mkOption {
        type = types.str;
        default = "0660";
        description = "Mode of the shared memory device.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (self: super: {
        looking-glass-client = super.looking-glass-client.overrideAttrs (oldAttrs: {
          version = "B7-rc1-d060e37";
          src = super.fetchFromGitHub {
            owner = "gnif";
            repo = "LookingGlass";
            rev = "d060e375ea47e4ca38894ea7bf02a85dbe29b1f8";
            hash = "sha256-ne1Q+67+P8RHcTsqdiSSwkFf0g3pSNT91WN/lsSzssU=";
            fetchSubmodules = true;
          };
        });
      })
    ];

    environment.systemPackages = with pkgs; [
      virt-manager
      qemu
      OVMFFull

      # for switching the input on my monitor
      ddcutil
    ] ++ lib.optional cfg.kvmfr.enable looking-glass-client;

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
      "d ${cfg.isosPath} 0770 ${cfg.user} ${cfg.group} -"
      "d ${cfg.storagePath} 0770 ${cfg.user} ${cfg.group} -"
      "d ${cfg.nvramPath} 0770 ${cfg.user} ${cfg.group} -"
    ];

    services.udev.extraRules = lib.mkIf cfg.kvmfr.enable ''
      SUBSYSTEM=="kvmfr", OWNER="${cfg.user}", GROUP="${cfg.group}", MODE="${cfg.kvmfr.mode}"
    '';

    boot = {
      extraModulePackages = lib.mkIf cfg.kvmfr.enable (with config.boot.kernelPackages; [
        kvmfr
      ]);
      kernelModules = [ "kvm-amd" "i2c-dev" ];

      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ]; #++ lib.optional cfg.kvmfr.enable "kvmfr";

      kernelParams = [
        "amd_iommu=on"
      ];

      extraModprobeConfig = ''
        options kvm_amd avic=1 nested=0 sev=0
        options vfio-pci ids=${lib.concatStringsSep "," cfg.pciIDs}
      '' + (if cfg.kvmfr.enable then "options kvmfr static_size_mb=${builtins.toString cfg.kvmfr.size}" else "");
    };
  };
}