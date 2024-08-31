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
      default = "libvirtd";
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
          version = "B7-rc1-3ea37b8";
          src = super.fetchFromGitHub {
            owner = "gnif";
            repo = "LookingGlass";
            rev = "3ea37b86e38a87ee35eefb5d8fcc38b8dc8e2903";
            hash = "sha256-DuCznF2b3kbt6OfoOUD3ijJ1im7anxj25/xcQnIVnWc=";
            fetchSubmodules = true;
          };
          patches = [];
        });
      })
    ];

    environment.systemPackages = with pkgs; [
      virt-manager
      qemu
      OVMFFull
    
      virtiofsd

      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          looking-glass-obs
        ];
      })

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
          verbatimConfig = ''
            user = "${cfg.user}"
            group = "${cfg.group}"

            cgroup_device_acl = [
                "/dev/kvmfr0",
                "/dev/null", "/dev/full", "/dev/zero",
                "/dev/random", "/dev/urandom",
                "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
                "/dev/rtc","/dev/hpet", "/dev/vfio/vfio"
            ]
          '';
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
      ] ++ lib.optional cfg.kvmfr.enable "kvmfr";

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